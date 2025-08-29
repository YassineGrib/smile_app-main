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
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = planType;
        });
        _proceedToPayment(planType, title, price);
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
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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