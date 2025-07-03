import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';

class AdminChildrenScreen extends StatefulWidget {
  const AdminChildrenScreen({super.key});

  @override
  State<AdminChildrenScreen> createState() => _AdminChildrenScreenState();
}

class _AdminChildrenScreenState extends State<AdminChildrenScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // Mock children data
  final List<Map<String, dynamic>> _children = [
    {
      'id': '001',
      'name': 'Ahmed Benali',
      'age': '3 years',
      'parentName': 'Fatima Benali',
      'phone': '+213 555 123 456',
      'plan': 'Full Day Care',
      'startDate': '2024-01-15',
      'status': 'Active',
      'emergencyContact': '+213 555 987 654',
      'allergies': 'None',
      'medicalNotes': 'Regular checkups needed',
    },
    {
      'id': '002',
      'name': 'Yasmine Khelifi',
      'age': '2 years',
      'parentName': 'Omar Khelifi',
      'phone': '+213 555 789 012',
      'plan': 'Half Day Care',
      'startDate': '2024-01-10',
      'status': 'Active',
      'emergencyContact': '+213 555 456 789',
      'allergies': 'Peanuts',
      'medicalNotes': 'Asthma - inhaler available',
    },
    {
      'id': '003',
      'name': 'Lina Boumediene',
      'age': '4 years',
      'parentName': 'Karim Boumediene',
      'phone': '+213 555 901 234',
      'plan': 'Half Day Care',
      'startDate': '2024-01-08',
      'status': 'Active',
      'emergencyContact': '+213 555 234 567',
      'allergies': 'Dairy',
      'medicalNotes': 'Lactose intolerant',
    },
  ];

  void _showChildDetails(Map<String, dynamic> child) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${child['name']} - Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', child['id']),
              _buildDetailRow('Age', child['age']),
              _buildDetailRow('Parent', child['parentName']),
              _buildDetailRow('Phone', child['phone']),
              _buildDetailRow('Emergency Contact', child['emergencyContact']),
              _buildDetailRow('Plan', child['plan']),
              _buildDetailRow('Start Date', child['startDate']),
              _buildDetailRow('Status', child['status']),
              _buildDetailRow('Allergies', child['allergies']),
              _buildDetailRow('Medical Notes', child['medicalNotes']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditChild(child);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showEditChild(Map<String, dynamic> child) {
    // This would open an edit form - simplified for demo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit functionality for ${child['name']} would open here'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Children Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/admin/dashboard'),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header Stats
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_children.length}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Active Children',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '2',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Full Day',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppTheme.infoColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '2',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.infoColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Half Day',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Children List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: _children.length,
                  itemBuilder: (context, index) {
                    final child = _children[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      ),
                      child: InkWell(
                        onTap: () => _showChildDetails(child),
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                    child: Text(
                                      child['name'][0],
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child['name'],
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Age: ${child['age']}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppTheme.textSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                    ),
                                    child: Text(
                                      child['status'],
                                      style: TextStyle(
                                        color: AppTheme.successColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 16,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    child['parentName'],
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Icon(
                                    Icons.school,
                                    size: 16,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    child['plan'],
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              if (child['allergies'] != 'None') ...[
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      size: 16,
                                      color: AppTheme.warningColor,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Allergies: ${child['allergies']}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.warningColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
