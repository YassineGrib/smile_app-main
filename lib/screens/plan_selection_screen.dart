import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import 'payment_screen.dart';

class PlanSelectionScreen extends StatefulWidget {
  final String childName;
  final int childAgeInMonths;
  final String childGender;

  const PlanSelectionScreen({
    Key? key,
    required this.childName,
    required this.childAgeInMonths,
    required this.childGender,
  }) : super(key: key);

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  bool isMonthlySelected = false;
  String? selectedPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Choose Your Plan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Age Group Display
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.child_care, color: Colors.blue, size: 30),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Child\'s Age Group',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      _getAgeGroupText(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Monthly/Daily Toggle
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMonthlySelected = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isMonthlySelected ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Daily',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !isMonthlySelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMonthlySelected = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isMonthlySelected ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Monthly',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isMonthlySelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Plans Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: isMonthlySelected ? 1 : 2, // عمود واحد للشهري، عمودان لليومي
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isMonthlySelected ? 2.5 : 0.85,
              children: [
                _buildPlanCard(
                    'day',
                    isMonthlySelected ? 'Day Care' : 'Morning Care',
                    '07:30 - 14:30',
                    Icons.wb_sunny,
                    Colors.blue,
                    isMonthlySelected ? _getMonthlyPrice('day') : 500,
                  ),
                if (!isMonthlySelected) // إخفاء الرعاية المسائية في الاشتراك الشهري
                  _buildPlanCard(
                    'evening',
                    'Evening Care',
                    '14:30 - 21:30',
                    Icons.wb_twilight,
                    Colors.orange,
                    500,
                  ),
                _buildPlanCard(
                  'night',
                  'Night Care',
                  '21:30 - 07:00',
                  Icons.nightlight_round,
                  Colors.green,
                  isMonthlySelected ? _getMonthlyPrice('night') : 600,
                ),
                _buildPlanCard(
                  'fullDay',
                  'Full Day Care',
                  '07:30 - 21:30',
                  Icons.all_inclusive,
                  Colors.teal,
                  isMonthlySelected ? _getMonthlyPrice('fullDay') : 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    String planType,
    String title,
    String time,
    IconData icon,
    Color color,
    int price,
  ) {
    final isSelected = selectedPlan == planType;
    final activities = _getActivitiesForPlan(planType);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = planType;
        });
        _proceedToPayment(planType, title, price);
      },
      onLongPress: () {
        _showActivitiesDialog(title, activities, color, icon);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '$price DA / ${isMonthlySelected ? 'Month' : 'Day'}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Long press for details',
                  style: TextStyle(
                    fontSize: 8,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAgeGroupText() {
    if (widget.childAgeInMonths >= 3 && widget.childAgeInMonths < 24) {
      return '3 months to 2 years';
    } else {
      return '2 to 5 years';
    }
  }

  void _showActivitiesDialog(String title, List<String> activities, Color color, IconData icon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Text(
                            _getAgeGroupText(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: color,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Included activities:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ...activities.map((activity) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                activity,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'حسناً',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<String> _getActivitiesForPlan(String planType) {
    final isYoungerGroup = widget.childAgeInMonths >= 3 && widget.childAgeInMonths < 24;
    
    if (isYoungerGroup) {
      // For children from 3 months to 2 years
      switch (planType) {
        case 'day': // Morning Care
          return [
            'Sensory play (colors, sounds, textures)',
            'Songs and Rhymes in multiple languages',
            'Breakfast and rest time'
          ];
        case 'evening':
          return [
            'Fine motor play (blocks, shape sorting)',
            'Picture Books about family and health',
            'Simple musical activities',
            'Snack and wind-down'
          ];
        case 'night':
          return [
            'Safe quiet sleep environment',
            'Soothing lullabies',
            'Consistent bedtime routine'
          ];
        case 'fullDay':
          return [
            'Sensory play (colors, sounds, textures)',
            'Songs and Rhymes in multiple languages',
            'Fine motor play (blocks, shape sorting)',
            'Picture Books about family and health',
            'Breakfast and rest time'
          ];
        default:
          return [];
      }
    } else {
      // For children from 2 to 5 years
      switch (planType) {
        case 'day': // Morning Care
          return [
            'Educational activities (colors, numbers, body parts)',
            'Little helpers workshop (medical tools intro)',
            'Group games (Building, cooperation)',
            'Breakfast and outdoor play'
          ];
        case 'evening':
          return [
            'Role play (Doctors and Nurses)',
            'Art activities (coloring and drawing)',
            'Educational games (matching tools to names)',
            'Snack and Relaxation'
          ];
        case 'night':
          return [
            'Storytime before bed',
            'Relaxation activities (simple breathing exercises)',
            'Structured bedtime routine'
          ];
        case 'fullDay':
          return [
            'Educational activities (colors, numbers, body parts)',
            'Little helpers workshop (medical tools intro)',
            'Role play (Doctors and Nurses)',
            'Art activities (coloring and drawing)',
            'Breakfast and outdoor play'
          ];
        default:
          return [];
      }
    }
  }

  int _getMonthlyPrice(String planType) {
    final isYoungerGroup = widget.childAgeInMonths >= 3 && widget.childAgeInMonths < 24;
    
    switch (planType) {
      case 'day':
        return isYoungerGroup ? 7000 : 5000;
      case 'evening':
        return 0; // لا يوجد اشتراك شهري للرعاية المسائية
      case 'night':
        return isYoungerGroup ? 3000 : 3000;
      case 'fullDay':
        return isYoungerGroup ? 10000 : 8000;
      default:
        return 0;
    }
  }

  void _proceedToPayment(String planType, String planName, int price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          childName: widget.childName,
          childAge: widget.childAgeInMonths,
          planType: planName,
          planPrice: price,
          isMonthly: isMonthlySelected,
        ),
      ),
    );
  }
}