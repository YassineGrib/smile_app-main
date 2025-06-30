import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        
        // Dropdown
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: DropdownButtonFormField<T>(
            value: widget.value,
            items: widget.items,
            onChanged: widget.enabled ? widget.onChanged : null,
            validator: widget.validator,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.enabled ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              filled: true,
              fillColor: widget.enabled ? AppTheme.cardColor : AppTheme.cardColor.withOpacity(0.5),
              
              // Prefix Icon
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                      size: 20,
                    )
                  : null,
              
              // Borders
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: BorderSide(
                  color: AppTheme.textLightColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: const BorderSide(
                  color: AppTheme.errorColor,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: const BorderSide(
                  color: AppTheme.errorColor,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: BorderSide(
                  color: AppTheme.textLightColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
            
            // Dropdown styling
            dropdownColor: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            elevation: 8,
            icon: Icon(
              Icons.arrow_drop_down,
              color: widget.enabled ? AppTheme.textSecondaryColor : AppTheme.textLightColor,
            ),
            iconSize: 24,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}

// Specialized dropdowns for common use cases
class GenderDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const GenderDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Gender',
      hint: 'Select gender',
      prefixIcon: Icons.person,
      value: value,
      items: const [
        DropdownMenuItem(
          value: 'male',
          child: Text('Male'),
        ),
        DropdownMenuItem(
          value: 'female',
          child: Text('Female'),
        ),
      ],
      onChanged: onChanged,
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a gender';
    }
    return null;
  }
}

class TimePeriodDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const TimePeriodDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Time Period',
      hint: 'Select time period',
      prefixIcon: Icons.access_time,
      value: value,
      items: AppConstants.timePeriods.map((period) {
        return DropdownMenuItem<String>(
          value: period['id'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                period['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                period['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a time period';
    }
    return null;
  }
}

class PlanTypeDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const PlanTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Plan Type',
      hint: 'Select plan type',
      prefixIcon: Icons.card_membership,
      value: value,
      items: const [
        DropdownMenuItem(
          value: 'basic',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Basic Plan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '6,000 DA / month',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'premium',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Premium Plan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '10,000 DA / month',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
      onChanged: onChanged,
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a plan type';
    }
    return null;
  }
}

class PaymentMethodDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const PaymentMethodDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Payment Method',
      hint: 'Select payment method',
      prefixIcon: Icons.payment,
      value: value,
      items: const [
        DropdownMenuItem(
          value: 'ccp',
          child: Row(
            children: [
              Icon(Icons.account_balance, size: 20, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text('CCP Account'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'baridi_mob',
          child: Row(
            children: [
              Icon(Icons.phone_android, size: 20, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text('BaridiMob'),
            ],
          ),
        ),
      ],
      onChanged: onChanged,
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a payment method';
    }
    return null;
  }
}
