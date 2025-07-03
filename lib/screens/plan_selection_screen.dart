import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';

class PlanSelectionScreen extends StatefulWidget {
  const PlanSelectionScreen({super.key});

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen>
    with TickerProviderStateMixin {
  String? _selectedPlan;
  String _selectedDuration = 'monthly'; // 'daily', 'weekly', 'monthly'
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock child age data - in real app, this would come from previous screen
  int childAgeInMonths = 18; // Default 18 months for demo

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = Uri.parse(GoRouterState.of(context).uri.toString());
    final ageParam = uri.queryParameters['ageInMonths'];
    if (ageParam != null) {
      final parsed = int.tryParse(ageParam);
      if (parsed != null) {
        setState(() {
          childAgeInMonths = parsed;
        });
      }
    }
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
    super.dispose();
  }

  // Get pricing based on age and care type
  Map<String, int> _getPricing() {
    // Convert months to years for easier calculation
    final ageInYears = childAgeInMonths / 12;

    if (ageInYears < 2) {
      // من 3 أشهر إلى غاية 2 سنة
      return {
        'morning': 5000,    // صباح
        'evening': 5000,    // مساء
        'night': 4000,      // ليل
        'fullDay': 10000,   // يوم كامل
      };
    } else {
      // من 2 سنة إلى 5 سنوات
      return {
        'morning': 4000,    // صباح
        'evening': 4000,    // مساء
        'night': 4000,      // ليل
        'fullDay': 10000,   // يوم كامل
      };
    }
  }

  double _getAdjustedPrice(int basePrice) {
    switch (_selectedDuration) {
      case 'daily':
        return basePrice / 30; // Assuming base price is monthly
      case 'weekly':
        return (basePrice / 30) * 7 * 0.9; // 10% discount
      case 'monthly':
      default:
        return basePrice.toDouble();
    }
  }

  String _getDurationText() {
    switch (_selectedDuration) {
      case 'daily':
        return '/ Day';
      case 'weekly':
        return '/ Week';
      case 'monthly':
      default:
        return '/ Month';
    }
  }

  String _getAgeGroup() {
    final ageInYears = childAgeInMonths / 12;
    if (ageInYears < 2) {
      return '3 months to 2 years';
    } else {
      return '2 years to 5 years';
    }
  }

  void _fillDemoData() {
    // Select full day plan as demo
    setState(() {
      _selectedPlan = 'fullDay';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo plan selected - Full Day Care'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onPlanSelected(String planType) {
    setState(() {
      _selectedPlan = planType;
    });

    // Show plan details
    _showPlanDetails(planType);
  }

  void _showPlanDetails(String planType) {
    final pricing = _getPricing();
    final ageGroup = _getAgeGroup();

    Map<String, dynamic> planInfo = {};

    switch (planType) {
      case 'morning':
        planInfo = {
          'name': 'Morning Care',
          'nameEn': 'Morning Care',
          'price': pricing['morning']!,
          'icon': Icons.wb_sunny,
          'color': AppTheme.primaryColor,
          'features': [
            'Care from 7:00 AM to 12:00 PM',
            'Healthy breakfast included',
            'Educational morning activities',
            'Continuous medical monitoring',
            'Daily reports for parents',
            'Offer: 10% off for the first month',
          ],
        };
        break;
      case 'evening':
        planInfo = {
          'name': 'Evening Care',
          'nameEn': 'Evening Care',
          'price': pricing['evening']!,
          'icon': Icons.wb_twilight,
          'color': AppTheme.secondaryColor,
          'features': [
            'Care from 12:00 PM to 6:00 PM',
            'Healthy lunch included',
            'Recreational evening activities',
            'Organized nap time',
            'Daily reports for parents',
            'Offer: Free trial for 3 days',
          ],
        };
        break;
      case 'night':
        planInfo = {
          'name': 'Night Care',
          'nameEn': 'Night Care',
          'price': pricing['night']!,
          'icon': Icons.nightlight,
          'color': AppTheme.infoColor,
          'features': [
            'Care from 6:00 PM to 7:00 AM',
            'Healthy dinner included',
            'Comfortable monitored sleep',
            'Specialized night care',
            'Morning reports for parents',
            'Offer: 5% discount on weekly bookings',
          ],
        };
        break;
      case 'fullDay':
        planInfo = {
          'name': 'Full Day Care',
          'nameEn': 'Full Day Care',
          'price': pricing['fullDay']!,
          'icon': Icons.all_inclusive,
          'color': AppTheme.successColor,
          'features': [
            '24-hour care (morning + evening + night)',
            'All healthy meals included',
            'Diverse activities throughout the day',
            'Comfortable monitored sleep',
            'Complete and comprehensive care',
            'Save 2000 DA monthly',
            'Offer: Free registration for yearly plans',
          ],
        };
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
              planInfo['icon'],
              color: planInfo['color'],
              size: 28,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planInfo['nameEn'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    planInfo['name'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Age Group Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  'Age Group: $ageGroup',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Included Services:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...planInfo['features'].map<Widget>((feature) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: AppSpacing.lg),

              // Price
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: planInfo['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  '${_getAdjustedPrice(planInfo['price']).toStringAsFixed(0)} DA ${_getDurationText()}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: planInfo['color'],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitSelection();
            },
            child: const Text('Select This Plan'),
          ),
        ],
      ),
    );
  }

  void _submitSelection() {
    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a plan'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate processing delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to payment screen
      context.go('/registration/payment');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/registration/parent-info'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: 0.6, // 60% progress (step 3 of 5)
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
                    'Choose the perfect plan',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Select the plan that best fits your child\'s needs and your family\'s schedule.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Age Group Display
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.face,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your Child\'s Age Group',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _getAgeGroup(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Duration Selector
            _buildDurationSelector(),

            const SizedBox(height: AppSpacing.lg),

            // Plan Cards
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                // Grid of plan cards
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  shrinkWrap: true,
                  childAspectRatio: 0.8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPlanCard(
                      planType: 'morning',
                      title: 'Morning Care',
                      price: _getPricing()['morning']!,
                      icon: Icons.wb_sunny,
                      color: AppTheme.primaryColor,
                    ),
                    _buildPlanCard(
                      planType: 'evening',
                      title: 'Evening Care',
                      price: _getPricing()['evening']!,
                      icon: Icons.wb_twilight,
                      color: AppTheme.secondaryColor,
                    ),
                    _buildPlanCard(
                      planType: 'night',
                      title: 'Night Care',
                      price: _getPricing()['night']!,
                      icon: Icons.nightlight,
                      color: AppTheme.infoColor,
                    ),
                    _buildPlanCard(
                      planType: 'fullDay',
                      title: 'Full Day Care',
                      price: _getPricing()['fullDay']!,
                      icon: Icons.all_inclusive,
                      color: AppTheme.successColor,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Comparison Note
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
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
                            'Plan Benefits',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.infoColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You can upgrade or change your plan at any time. All plans include our core safety and care standards.',
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
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Continue Button
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitSelection,
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
                            const Text('Continue with Selected Plan'),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String planType,
    required String title,
    required int price,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = _selectedPlan == planType;
    
    return GestureDetector(
      onTap: () => _onPlanSelected(planType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isSelected ? color : AppTheme.textLightColor.withOpacity(0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${_getAdjustedPrice(price).toStringAsFixed(0)} DA ${_getDurationText()}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return ToggleButtons(
      isSelected: [
        _selectedDuration == 'daily',
        _selectedDuration == 'weekly',
        _selectedDuration == 'monthly',
      ],
      onPressed: (index) {
        setState(() {
          if (index == 0) _selectedDuration = 'daily';
          if (index == 1) _selectedDuration = 'weekly';
          if (index == 2) _selectedDuration = 'monthly';
        });
      },
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      selectedColor: Colors.white,
      fillColor: AppTheme.primaryColor,
      color: AppTheme.primaryColor,
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: (MediaQuery.of(context).size.width - 52) / 3,
      ),
      children: const [
        Text('Daily'),
        Text('Weekly'),
        Text('Monthly'),
      ],
    );
  }
}
