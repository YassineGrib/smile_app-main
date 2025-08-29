import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_text_field.dart';
import '../services/demo_data_service.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PaymentScreen extends StatefulWidget {
  final String childName;
  final int childAge;
  final String planType;
  final int planPrice;
  final bool isMonthly;

  const PaymentScreen({
    super.key,
    required this.childName,
    required this.childAge,
    required this.planType,
    required this.planPrice,
    required this.isMonthly,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  
  String? _selectedPaymentMethod;
  PlatformFile? _paymentScreenshot;
  bool _isLoading = false;
  
  // Plan details from previous screen
  late String _selectedPlan;
  late String _selectedDuration;
  late int _price;
  late int _childAgeInMonths;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize plan details from widget
    _selectedPlan = widget.planType;
    _selectedDuration = widget.isMonthly ? 'monthly' : 'daily';
    _price = widget.planPrice;
    _childAgeInMonths = widget.childAge;
    
    _initializeAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  String _getPlanName() {
    switch (_selectedPlan) {
      case 'morning':
        return 'Morning Care';
      case 'evening':
        return 'Evening Care';
      case 'night':
        return 'Night Care';
      case 'fullDay':
        return 'Full Day Care';
      default:
        return 'Selected Plan';
    }
  }

  String _getDurationText() {
    switch (_selectedDuration) {
      case 'daily':
        return '/ Day';
      case 'monthly':
      default:
        return '/ Month';
    }
  }

  String _getAgeGroup() {
    if (_childAgeInMonths == null) return '';
    
    final isYoungerGroup = _childAgeInMonths! >= AppConstants.minAgeMonths && 
                          _childAgeInMonths! < AppConstants.twoYearsMonths;
    
    if (isYoungerGroup) {
      return '3 months to 2 years';
    } else {
      return '2 years to 5 years';
    }
  }

  void _onPaymentMethodChanged(String? method) {
    setState(() {
      _selectedPaymentMethod = method;
      // Clear form when switching methods
      _accountNumberController.clear();
      _accountHolderController.clear();
      _paymentScreenshot = null;
    });
  }

  Future<void> _pickPaymentScreenshot() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _paymentScreenshot = result.files.first;
        });
        _showSuccessSnackBar('Payment screenshot selected successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick screenshot. Please try again.');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitPayment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPaymentMethod == null) {
      _showErrorSnackBar('Please select a payment method');
      return;
    }

    if (_paymentScreenshot == null) {
      _showErrorSnackBar('Please upload payment screenshot');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to confirmation screen
      context.go('/registration/confirmation');
    });
  }

  void _fillDemoData() async {
    final demoData = DemoDataService.generatePaymentData();
    PlatformFile? demoScreenshot;
    try {
      // Load asset as bytes
      final byteData = await rootBundle.load('assets/images/logo.png');
      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/demo_payment_logo.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());
      demoScreenshot = PlatformFile(
        name: 'demo_payment_logo.png',
        path: tempFile.path,
        size: byteData.lengthInBytes,
        bytes: byteData.buffer.asUint8List(),
      );
    } catch (e) {
      demoScreenshot = null;
    }
    setState(() {
      _selectedPaymentMethod = demoData['paymentMethod'];
      _accountNumberController.text = demoData['accountNumber'];
      _accountHolderController.text = demoData['accountHolder'];
      _paymentScreenshot = demoScreenshot;
    });
    _showSuccessSnackBar('Demo payment data filled!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/registration/plan-selection'),
        ),
        actions: [
          IconButton(
            onPressed: _fillDemoData,
            icon: const Icon(Icons.auto_fix_high),
            tooltip: 'Fill Demo Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              LinearProgressIndicator(
                value: 0.8, // 80% progress (step 4 of 5)
                backgroundColor: AppTheme.cardColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Header
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Payment Method',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Select your preferred payment method and provide the required information.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Plan Summary
              if (_selectedPlan != null && _price != null) ...[
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.summarize,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Plan Summary',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _getPlanName(),
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Text(
                                    '${_price} ${AppConstants.currency}${_getDurationText()}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (_childAgeInMonths != null) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Age Group: ${_getAgeGroup()}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              
              // Payment Methods
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Methods',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      
                      // CCP Option
                      _buildPaymentMethodCard(
                        method: 'ccp',
                        title: 'CCP (Compte Chèques Postaux)',
                        subtitle: 'Pay using your CCP account',
                        icon: Icons.account_balance,
                        color: AppTheme.primaryColor,
                      ),
                      
                      const SizedBox(height: AppSpacing.md),
                      
                      // BaridiMob Option
                      _buildPaymentMethodCard(
                        method: 'baridimob',
                        title: 'BaridiMob',
                        subtitle: 'Pay using BaridiMob mobile app',
                        icon: Icons.phone_android,
                        color: AppTheme.secondaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Payment Details Form
              if (_selectedPaymentMethod != null) ...[
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _selectedPaymentMethod == 'ccp' 
                                    ? Icons.account_balance 
                                    : Icons.phone_android,
                                color: _selectedPaymentMethod == 'ccp' 
                                    ? AppTheme.primaryColor 
                                    : AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                _selectedPaymentMethod == 'ccp' 
                                    ? 'CCP Payment Details' 
                                    : 'BaridiMob Payment Details',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Account Number Field
                          CustomTextField(
                            controller: _accountNumberController,
                            label: _selectedPaymentMethod == 'ccp' 
                                ? 'CCP Account Number' 
                                : 'BaridiMob Phone Number',
                            hint: _selectedPaymentMethod == 'ccp' 
                                ? 'Enter your CCP account number' 
                                : 'Enter your BaridiMob phone number',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (_selectedPaymentMethod == 'ccp' && value.length < 10) {
                                return 'CCP account number must be at least 10 digits';
                              }
                              if (_selectedPaymentMethod == 'baridimob' && value.length != 10) {
                                return 'Phone number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          
                          // Account Holder Name
                          CustomTextField(
                            controller: _accountHolderController,
                            label: 'Account Holder Name',
                            hint: 'Enter the account holder\'s full name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Account holder name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Payment Screenshot Upload
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppTheme.infoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                              border: Border.all(
                                color: AppTheme.infoColor.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: AppTheme.infoColor,
                                  size: 32,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Upload Payment Screenshot',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.infoColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Please upload a screenshot of your payment confirmation',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.infoColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                
                                if (_paymentScreenshot != null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.md),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: AppTheme.successColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Expanded(
                                          child: Text(
                                            _paymentScreenshot!.name,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.successColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                ],
                                
                                OutlinedButton.icon(
                                  onPressed: _pickPaymentScreenshot,
                                  icon: Icon(_paymentScreenshot != null ? Icons.change_circle : Icons.upload),
                                  label: Text(_paymentScreenshot != null ? 'Change Screenshot' : 'Upload Screenshot'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.infoColor,
                                    side: BorderSide(color: AppTheme.infoColor.withOpacity(0.5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              
              // Submit Button
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitPayment,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Complete Payment'),
                              const SizedBox(width: AppSpacing.sm),
                              const Icon(Icons.payment, size: 20),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String method,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedPaymentMethod == method;
    
    return GestureDetector(
      onTap: () => _onPaymentMethodChanged(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isSelected ? color : AppTheme.textLightColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? color.withOpacity(0.2) : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? color : AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Selection indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : AppTheme.textLightColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(AppBorderRadius.round),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
