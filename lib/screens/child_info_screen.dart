import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/health_condition_selector.dart';
import '../services/demo_data_service.dart';

class ChildInfoScreen extends StatefulWidget {
  const ChildInfoScreen({super.key});

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedGender;
  List<String> _selectedHealthConditions = [];
  PlatformFile? _medicalFile;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 6)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickMedicalFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // Check file size (5MB limit)
        if (file.size > AppConstants.maxFileSize) {
          _showErrorSnackBar('File size must be less than 5MB');
          return;
        }
        
        setState(() {
          _medicalFile = file;
        });
        
        _showSuccessSnackBar('Medical file selected successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick file. Please try again.');
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onHealthConditionsChanged(List<String> conditions) {
    setState(() {
      _selectedHealthConditions = conditions;
    });
    
    // Show alert if special health condition is selected
    if (conditions.any((condition) => 
        condition != 'No health issues' && condition.isNotEmpty)) {
      _showHealthAlert();
    }
  }

  void _showHealthAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: Row(
          children: [
            Icon(
              Icons.health_and_safety,
              color: AppTheme.warningColor,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Health Notice'),
          ],
        ),
        content: const Text(
          'Our staff will be informed about your child\'s health condition to ensure proper care and attention.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  // Calculate age from birth date
  Map<String, int> _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    if (months < 0) {
      years--;
      months += 12;
    }

    if (now.day < birthDate.day) {
      months--;
      if (months < 0) {
        years--;
        months += 12;
      }
    }

    return {'years': years, 'months': months};
  }

  String _getAgeText(DateTime birthDate) {
    final age = _calculateAge(birthDate);
    final years = age['years']!;
    final months = age['months']!;

    if (years == 0) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else if (months == 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    } else {
      return '$years ${years == 1 ? 'year' : 'years'} and $months ${months == 1 ? 'month' : 'months'}';
    }
  }

  void _fillDemoData() {
    // Show a confirmation dialog before filling
    final demoData = DemoDataService.generateChildInfo();

    _nameController.text = demoData['fullName'];
    setState(() {
      _selectedDate = demoData['birthDate'];
      _selectedGender = demoData['gender'];
      _addressController.text = demoData['address'];
      _selectedHealthConditions = List<String>.from(demoData['healthConditions']);
      _notesController.text = demoData['notes'];
    });

    _showSuccessSnackBar('Demo data filled successfully!');
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      _showErrorSnackBar('Please select your child\'s birth date');
      return;
    }

    if (_selectedGender == null) {
      _showErrorSnackBar('Please select your child\'s gender');
      return;
    }

    // Calculate age in months
    final now = DateTime.now();
    int ageInMonths = (now.year - _selectedDate!.year) * 12 + (now.month - _selectedDate!.month);
    if (now.day < _selectedDate!.day) {
      ageInMonths--;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate form submission delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      // Navigate to parent info screen, passing all child info
      final childName = Uri.encodeComponent(_nameController.text.trim());
      final childGender = Uri.encodeComponent(_selectedGender!);
      context.go('/registration/parent-info?ageInMonths=$ageInMonths&childName=$childName&childGender=$childGender');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
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
                value: 0.2, // 20% progress (step 1 of 5)
                backgroundColor: AppTheme.cardColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Header
              Text(
                'Tell us about your child',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please provide your child\'s basic information for enrollment.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Full Name
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your child\'s full name',
                prefixIcon: Icons.child_care,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your child\'s name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Birth Date
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    border: Border.all(
                      color: AppTheme.textLightColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Birth Date',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedDate != null
                                  ? DateFormat('MMMM dd, yyyy').format(_selectedDate!)
                                  : 'Select birth date',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _selectedDate != null
                                    ? AppTheme.textPrimaryColor
                                    : AppTheme.textSecondaryColor,
                              ),
                            ),
                            if (_selectedDate != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Age: ${_getAgeText(_selectedDate!)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Gender
              CustomDropdown<String>(
                label: 'Gender',
                hint: 'Select gender',
                prefixIcon: Icons.person,
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
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
              const SizedBox(height: AppSpacing.lg),
              
              // Health Conditions
              HealthConditionSelector(
                selectedConditions: _selectedHealthConditions,
                onChanged: _onHealthConditionsChanged,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Additional Notes
              CustomTextField(
                controller: _notesController,
                label: 'Additional Notes (Optional)',
                hint: 'Any additional information about your child...',
                prefixIcon: Icons.note,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Medical File Upload
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(
                    color: AppTheme.primaryLightColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Medical File (Optional)',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Upload medical documents or reports (PDF, DOC, or images)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    if (_medicalFile != null) ...[
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
                                _medicalFile!.name,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _medicalFile = null;
                                });
                              },
                              icon: Icon(
                                Icons.close,
                                color: AppTheme.textSecondaryColor,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    
                    OutlinedButton.icon(
                      onPressed: _pickMedicalFile,
                      icon: const Icon(Icons.upload_file),
                      label: Text(_medicalFile != null ? 'Change File' : 'Upload File'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.5)),
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
