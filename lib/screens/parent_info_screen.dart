import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../services/demo_data_service.dart';

class ParentInfoScreen extends StatefulWidget {
  const ParentInfoScreen({super.key});

  @override
  State<ParentInfoScreen> createState() => _ParentInfoScreenState();
}

class _ParentInfoScreenState extends State<ParentInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  
  String? _selectedTimePeriod;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showPricingAlert(String timePeriod) {
    String message = '';
    String title = '';
    Color alertColor = AppTheme.infoColor;
    
    switch (timePeriod) {
      case 'full_day':
        title = 'Full Day Pricing';
        message = 'Full day care (08:00 - 17:00) has higher pricing than individual periods. You\'ll see the exact pricing in the next step.';
        alertColor = AppTheme.warningColor;
        break;
      case 'morning':
        title = 'Morning Period';
        message = 'Morning period (08:00 - 12:00) - Perfect for working parents who need early care.';
        break;
      case 'evening':
        title = 'Evening Period';
        message = 'Evening period (13:00 - 17:00) - Great for afternoon activities and care.';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: Row(
          children: [
            Icon(
              Icons.access_time,
              color: alertColor,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _fillDemoData() {
    final demoData = DemoDataService.generateParentData();

    setState(() {
      _nameController.text = demoData['fullName'];
      _phoneController.text = demoData['phoneNumber'];
      _emailController.text = demoData['email'];
      _addressController.text = demoData['address'];
      _selectedTimePeriod = demoData['timePeriod'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo data filled successfully!'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onTimePeriodChanged(String? value) {
    setState(() {
      _selectedTimePeriod = value;
    });

    if (value != null) {
      _showPricingAlert(value);
    }
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTimePeriod == null) {
      _showErrorSnackBar('Please select a time period');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate form submission delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to plan selection screen
      context.go('/registration/plan-selection');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/registration/child-info'),
        ),
        actions: [
          IconButton(
            onPressed: _fillDemoData,
            icon: const Icon(Icons.auto_fix_high),
            tooltip: 'Fill Demo Data',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              LinearProgressIndicator(
                value: 0.4, // 40% progress (step 2 of 5)
                backgroundColor: AppTheme.cardColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Header
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please provide your contact information and preferred time period.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Full Name
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Phone Number
              PhoneTextField(
                controller: _phoneController,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Email Address
              EmailTextField(
                controller: _emailController,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Address
              CustomTextField(
                controller: _addressController,
                label: 'Address',
                hint: 'Enter your address',
                prefixIcon: Icons.location_on,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Time Period Selection
              Text(
                'Preferred Time Period',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Choose the time period that works best for your schedule',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Time Period Cards
              ...AppConstants.timePeriods.map((period) {
                final isSelected = _selectedTimePeriod == period['id'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InkWell(
                    onTap: () => _onTimePeriodChanged(period['id']),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(
                          color: isSelected 
                              ? AppTheme.primaryColor
                              : AppTheme.textLightColor.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Radio button
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected 
                                    ? AppTheme.primaryColor
                                    : AppTheme.textLightColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(AppBorderRadius.round),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          
                          // Time icon
                          Icon(
                            Icons.access_time,
                            color: isSelected 
                                ? AppTheme.primaryColor
                                : AppTheme.textSecondaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          
                          // Period details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  period['name'],
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isSelected 
                                        ? AppTheme.primaryColor
                                        : AppTheme.textPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  period['time'],
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  period['description'],
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Special indicator for full day
                          if (period['id'] == 'full_day')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.warningColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                              ),
                              child: Text(
                                'Higher Price',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.warningColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Contact Information Notice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(
                    color: AppTheme.infoColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.infoColor,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Information',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.infoColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'We\'ll use this information to send registration confirmation and important updates.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.infoColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.xxl),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
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
                            const Text('Continue'),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
