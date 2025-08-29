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
  
  bool _isLoading = false;
  int? _childAgeInMonths;
  String? _childName;
  String? _childGender;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final uri = Uri.parse(GoRouterState.of(context).uri.toString());
      final ageParam = uri.queryParameters['ageInMonths'];
      final nameParam = uri.queryParameters['childName'];
      final genderParam = uri.queryParameters['childGender'];
      
      if (ageParam != null) {
        _childAgeInMonths = int.tryParse(ageParam);
      }
      if (nameParam != null) {
        try {
          _childName = Uri.decodeComponent(nameParam);
        } catch (e) {
          _childName = nameParam; // Use original if decoding fails
        }
      }
      if (genderParam != null) {
        try {
          _childGender = Uri.decodeComponent(genderParam);
        } catch (e) {
          _childGender = genderParam; // Use original if decoding fails
        }
      }
    } catch (e) {
      // Handle URI parsing errors gracefully
      print('Error parsing URI parameters: $e');
    }
  }



  void _fillDemoData() {
    final demoData = DemoDataService.generateParentData();

    setState(() {
      _nameController.text = demoData['fullName'];
      _phoneController.text = demoData['phoneNumber'];
      _emailController.text = demoData['email'];
      _addressController.text = demoData['address'];

    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo data filled successfully!'),
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
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
      
      // Navigate to plan selection screen with all child info
      if (_childAgeInMonths != null && _childName != null && _childGender != null) {
        final childName = Uri.encodeComponent(_childName!);
        final childGender = Uri.encodeComponent(_childGender!);
        context.go('/registration/plan-selection?ageInMonths=$_childAgeInMonths&childName=$childName&childGender=$childGender');
      } else {
        context.go('/registration/plan-selection');
      }
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
