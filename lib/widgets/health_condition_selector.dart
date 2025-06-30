import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class HealthConditionSelector extends StatefulWidget {
  final List<String> selectedConditions;
  final void Function(List<String>) onChanged;

  const HealthConditionSelector({
    super.key,
    required this.selectedConditions,
    required this.onChanged,
  });

  @override
  State<HealthConditionSelector> createState() => _HealthConditionSelectorState();
}

class _HealthConditionSelectorState extends State<HealthConditionSelector> {
  final TextEditingController _otherController = TextEditingController();
  bool _showOtherField = false;

  @override
  void initState() {
    super.initState();
    _showOtherField = widget.selectedConditions.contains('Other');
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _onConditionChanged(String condition, bool isSelected) {
    List<String> newConditions = List.from(widget.selectedConditions);
    
    if (condition == 'No health issues') {
      if (isSelected) {
        // If "No health issues" is selected, clear all other conditions
        newConditions = ['No health issues'];
        _showOtherField = false;
        _otherController.clear();
      } else {
        newConditions.remove(condition);
      }
    } else {
      // If any other condition is selected, remove "No health issues"
      if (isSelected) {
        newConditions.remove('No health issues');
        newConditions.add(condition);
        
        if (condition == 'Other') {
          setState(() {
            _showOtherField = true;
          });
        }
      } else {
        newConditions.remove(condition);
        
        if (condition == 'Other') {
          setState(() {
            _showOtherField = false;
          });
          _otherController.clear();
        }
      }
      
      // If no conditions are selected, default to "No health issues"
      if (newConditions.isEmpty) {
        newConditions = ['No health issues'];
      }
    }
    
    widget.onChanged(newConditions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Health Conditions',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        
        // Description
        Text(
          'Please select any health conditions that apply to your child',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Health Conditions Grid
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(
              color: AppTheme.textLightColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              // Health conditions list
              ...AppConstants.healthConditions.map((condition) {
                final isSelected = widget.selectedConditions.contains(condition);
                final isNoHealthIssues = condition == 'No health issues';
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InkWell(
                    onTap: () => _onConditionChanged(condition, !isSelected),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (isNoHealthIssues 
                                ? AppTheme.successColor.withOpacity(0.1)
                                : AppTheme.warningColor.withOpacity(0.1))
                            : AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        border: Border.all(
                          color: isSelected 
                              ? (isNoHealthIssues 
                                  ? AppTheme.successColor
                                  : AppTheme.warningColor)
                              : AppTheme.textLightColor.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Checkbox
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? (isNoHealthIssues 
                                      ? AppTheme.successColor
                                      : AppTheme.warningColor)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected 
                                    ? (isNoHealthIssues 
                                        ? AppTheme.successColor
                                        : AppTheme.warningColor)
                                    : AppTheme.textLightColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          
                          // Condition text
                          Expanded(
                            child: Text(
                              condition,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                                    ? AppTheme.textPrimaryColor
                                    : AppTheme.textSecondaryColor,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          
                          // Icon for special conditions
                          if (condition != 'No health issues' && condition != 'Other')
                            Icon(
                              Icons.health_and_safety,
                              size: 16,
                              color: isSelected 
                                  ? AppTheme.warningColor
                                  : AppTheme.textLightColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              // Other condition text field
              if (_showOtherField) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    border: Border.all(
                      color: AppTheme.warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please specify the other health condition:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _otherController,
                        decoration: InputDecoration(
                          hintText: 'Describe the health condition...',
                          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(AppSpacing.md),
                        ),
                        maxLines: 2,
                        onChanged: (value) {
                          // Update the conditions list with the custom text
                          List<String> newConditions = List.from(widget.selectedConditions);
                          if (value.trim().isNotEmpty) {
                            // Replace "Other" with the specific condition
                            newConditions.remove('Other');
                            newConditions.add('Other: ${value.trim()}');
                          } else {
                            // Remove custom condition and add back "Other"
                            newConditions.removeWhere((condition) => condition.startsWith('Other:'));
                            if (!newConditions.contains('Other')) {
                              newConditions.add('Other');
                            }
                          }
                          widget.onChanged(newConditions);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Health notice
        if (widget.selectedConditions.any((condition) => 
            condition != 'No health issues' && condition.isNotEmpty)) ...[
          const SizedBox(height: AppSpacing.md),
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
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.infoColor,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Our staff will be informed about your child\'s health condition to ensure proper care.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.infoColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
