import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Pricing Controllers
  final _monthlyMorningPrice3m2yController = TextEditingController();
  final _monthlyEveningPrice3m2yController = TextEditingController();
  final _monthlyNightPrice3m2yController = TextEditingController();
  final _monthlyFullDayPrice3m2yController = TextEditingController();
  
  final _monthlyMorningPrice2y5yController = TextEditingController();
  final _monthlyEveningPrice2y5yController = TextEditingController();
  final _monthlyNightPrice2y5yController = TextEditingController();
  final _monthlyFullDayPrice2y5yController = TextEditingController();
  
  final _dailyMorningPrice3m2yController = TextEditingController();
  final _dailyEveningPrice3m2yController = TextEditingController();
  final _dailyNightPrice3m2yController = TextEditingController();
  final _dailyFullDayPrice3m2yController = TextEditingController();
  
  final _dailyMorningPrice2y5yController = TextEditingController();
  final _dailyEveningPrice2y5yController = TextEditingController();
  final _dailyNightPrice2y5yController = TextEditingController();
  final _dailyFullDayPrice2y5yController = TextEditingController();

  // Time Shift Controllers
  final _morningShiftController = TextEditingController();
  final _eveningShiftController = TextEditingController();
  final _fullDayController = TextEditingController();
  final _nightShiftController = TextEditingController();

  // Age Group Controllers
  final _minAgeMonthsController = TextEditingController();
  final _maxAgeMonthsController = TextEditingController();
  final _twoYearsMonthsController = TextEditingController();

  // Nursery Info Controllers
  final _nurseryNameController = TextEditingController();
  final _nurseryPhoneController = TextEditingController();
  final _nurseryEmailController = TextEditingController();
  final _nurseryAddressController = TextEditingController();
  final _nurseryCCPController = TextEditingController();

  // Working Hours Controllers
  final _appointmentStartHourController = TextEditingController();
  final _appointmentEndHourController = TextEditingController();
  final _appointmentSlotDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCurrentSettings();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  void _loadCurrentSettings() {
    // Load pricing values
    _monthlyMorningPrice3m2yController.text = AppConstants.monthlyMorningPrice3m2y.toString();
    _monthlyEveningPrice3m2yController.text = AppConstants.monthlyEveningPrice3m2y.toString();
    _monthlyNightPrice3m2yController.text = AppConstants.monthlyNightPrice3m2y.toString();
    _monthlyFullDayPrice3m2yController.text = AppConstants.monthlyFullDayPrice3m2y.toString();
    
    _monthlyMorningPrice2y5yController.text = AppConstants.monthlyMorningPrice2y5y.toString();
    _monthlyEveningPrice2y5yController.text = AppConstants.monthlyEveningPrice2y5y.toString();
    _monthlyNightPrice2y5yController.text = AppConstants.monthlyNightPrice2y5y.toString();
    _monthlyFullDayPrice2y5yController.text = AppConstants.monthlyFullDayPrice2y5y.toString();
    
    _dailyMorningPrice3m2yController.text = AppConstants.dailyMorningPrice3m2y.toString();
    _dailyEveningPrice3m2yController.text = AppConstants.dailyEveningPrice3m2y.toString();
    _dailyNightPrice3m2yController.text = AppConstants.dailyNightPrice3m2y.toString();
    _dailyFullDayPrice3m2yController.text = AppConstants.dailyFullDayPrice3m2y.toString();
    
    _dailyMorningPrice2y5yController.text = AppConstants.dailyMorningPrice2y5y.toString();
    _dailyEveningPrice2y5yController.text = AppConstants.dailyEveningPrice2y5y.toString();
    _dailyNightPrice2y5yController.text = AppConstants.dailyNightPrice2y5y.toString();
    _dailyFullDayPrice2y5yController.text = AppConstants.dailyFullDayPrice2y5y.toString();

    // Load time shifts
    _morningShiftController.text = AppConstants.morningShift;
    _eveningShiftController.text = AppConstants.eveningShift;
    _fullDayController.text = AppConstants.fullDay;
    _nightShiftController.text = AppConstants.nightShift;

    // Load age groups
    _minAgeMonthsController.text = AppConstants.minAgeMonths.toString();
    _maxAgeMonthsController.text = AppConstants.maxAgeMonths.toString();
    _twoYearsMonthsController.text = AppConstants.twoYearsMonths.toString();

    // Load nursery info
    _nurseryNameController.text = AppConstants.nurseryName;
    _nurseryPhoneController.text = AppConstants.nurseryPhone;
    _nurseryEmailController.text = AppConstants.nurseryEmail;
    _nurseryAddressController.text = AppConstants.nurseryAddress;
    _nurseryCCPController.text = AppConstants.nurseryCCP;

    // Load working hours
    _appointmentStartHourController.text = AppConstants.appointmentStartHour.toString();
    _appointmentEndHourController.text = AppConstants.appointmentEndHour.toString();
    _appointmentSlotDurationController.text = AppConstants.appointmentSlotDuration.toString();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _monthlyMorningPrice3m2yController.dispose();
    _monthlyEveningPrice3m2yController.dispose();
    _monthlyNightPrice3m2yController.dispose();
    _monthlyFullDayPrice3m2yController.dispose();
    _monthlyMorningPrice2y5yController.dispose();
    _monthlyEveningPrice2y5yController.dispose();
    _monthlyNightPrice2y5yController.dispose();
    _monthlyFullDayPrice2y5yController.dispose();
    _dailyMorningPrice3m2yController.dispose();
    _dailyEveningPrice3m2yController.dispose();
    _dailyNightPrice3m2yController.dispose();
    _dailyFullDayPrice3m2yController.dispose();
    _dailyMorningPrice2y5yController.dispose();
    _dailyEveningPrice2y5yController.dispose();
    _dailyNightPrice2y5yController.dispose();
    _dailyFullDayPrice2y5yController.dispose();
    _morningShiftController.dispose();
    _eveningShiftController.dispose();
    _fullDayController.dispose();
    _nightShiftController.dispose();
    _minAgeMonthsController.dispose();
    _maxAgeMonthsController.dispose();
    _twoYearsMonthsController.dispose();
    _nurseryNameController.dispose();
    _nurseryPhoneController.dispose();
    _nurseryEmailController.dispose();
    _nurseryAddressController.dispose();
    _nurseryCCPController.dispose();
    _appointmentStartHourController.dispose();
    _appointmentEndHourController.dispose();
    _appointmentSlotDurationController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    // In a real app, you would save these to a database or shared preferences
    // For now, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadCurrentSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults!'),
                  backgroundColor: AppTheme.infoColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/dashboard'),
        ),
        actions: [
          IconButton(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to Defaults',
          ),
          IconButton(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Manage App Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Update pricing, schedules, and other app constants',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Pricing Section
                _buildSectionHeader('Pricing Configuration', Icons.attach_money),
                const SizedBox(height: AppSpacing.lg),
                
                // Monthly Pricing - 3 months to 2 years
                _buildPricingSection(
                  'Monthly Pricing (3 months to 2 years)',
                  [
                    _buildPriceField('Morning', _monthlyMorningPrice3m2yController, 'DA/month'),
                    _buildPriceField('Evening', _monthlyEveningPrice3m2yController, 'DA/month'),
                    _buildPriceField('Night', _monthlyNightPrice3m2yController, 'DA/month'),
                    _buildPriceField('Full Day', _monthlyFullDayPrice3m2yController, 'DA/month'),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Monthly Pricing - 2 years to 5 years
                _buildPricingSection(
                  'Monthly Pricing (2 years to 5 years)',
                  [
                    _buildPriceField('Morning', _monthlyMorningPrice2y5yController, 'DA/month'),
                    _buildPriceField('Evening', _monthlyEveningPrice2y5yController, 'DA/month'),
                    _buildPriceField('Night', _monthlyNightPrice2y5yController, 'DA/month'),
                    _buildPriceField('Full Day', _monthlyFullDayPrice2y5yController, 'DA/month'),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Daily Pricing - 3 months to 2 years
                _buildPricingSection(
                  'Daily Pricing (3 months to 2 years)',
                  [
                    _buildPriceField('Morning', _dailyMorningPrice3m2yController, 'DA/day'),
                    _buildPriceField('Evening', _dailyEveningPrice3m2yController, 'DA/day'),
                    _buildPriceField('Night', _dailyNightPrice3m2yController, 'DA/day'),
                    _buildPriceField('Full Day', _dailyFullDayPrice3m2yController, 'DA/day'),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Daily Pricing - 2 years to 5 years
                _buildPricingSection(
                  'Daily Pricing (2 years to 5 years)',
                  [
                    _buildPriceField('Morning', _dailyMorningPrice2y5yController, 'DA/day'),
                    _buildPriceField('Evening', _dailyEveningPrice2y5yController, 'DA/day'),
                    _buildPriceField('Night', _dailyNightPrice2y5yController, 'DA/day'),
                    _buildPriceField('Full Day', _dailyFullDayPrice2y5yController, 'DA/day'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Time Shifts Section
                _buildSectionHeader('Time Shifts', Icons.schedule),
                const SizedBox(height: AppSpacing.lg),
                _buildTimeShiftSection(),
                const SizedBox(height: AppSpacing.xl),

                // Age Groups Section
                _buildSectionHeader('Age Groups', Icons.child_care),
                const SizedBox(height: AppSpacing.lg),
                _buildAgeGroupSection(),
                const SizedBox(height: AppSpacing.xl),

                // Nursery Information Section
                _buildSectionHeader('Nursery Information', Icons.business),
                const SizedBox(height: AppSpacing.lg),
                _buildNurseryInfoSection(),
                const SizedBox(height: AppSpacing.xl),

                // Working Hours Section
                _buildSectionHeader('Working Hours', Icons.access_time),
                const SizedBox(height: AppSpacing.lg),
                _buildWorkingHoursSection(),
                const SizedBox(height: AppSpacing.xl),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text('Save All Settings'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection(String title, List<Widget> fields) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...fields,
        ],
      ),
    );
  }

  Widget _buildPriceField(String label, TextEditingController controller, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter price',
                suffixText: unit,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeShiftSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildTimeField('Morning Shift', _morningShiftController),
          const SizedBox(height: AppSpacing.md),
          _buildTimeField('Evening Shift', _eveningShiftController),
          const SizedBox(height: AppSpacing.md),
          _buildTimeField('Full Day', _fullDayController),
          const SizedBox(height: AppSpacing.md),
          _buildTimeField('Night Shift', _nightShiftController),
        ],
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'e.g., 08:00 - 12:00',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeGroupSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildNumberField('Minimum Age (months)', _minAgeMonthsController),
          const SizedBox(height: AppSpacing.md),
          _buildNumberField('Maximum Age (months)', _maxAgeMonthsController),
          const SizedBox(height: AppSpacing.md),
          _buildNumberField('Two Years (months)', _twoYearsMonthsController),
        ],
      ),
    );
  }

  Widget _buildNurseryInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppTheme.infoColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildTextField('Nursery Name', _nurseryNameController),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('Phone Number', _nurseryPhoneController),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('Email', _nurseryEmailController),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('Address', _nurseryAddressController),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('CCP Number', _nurseryCCPController),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppTheme.warningColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildNumberField('Appointment Start Hour', _appointmentStartHourController),
          const SizedBox(height: AppSpacing.md),
          _buildNumberField('Appointment End Hour', _appointmentEndHourController),
          const SizedBox(height: AppSpacing.md),
          _buildNumberField('Slot Duration (minutes)', _appointmentSlotDurationController),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 