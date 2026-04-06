import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/phone_number.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

class MixedThemedDemo extends StatefulWidget {
  const MixedThemedDemo({super.key});

  @override
  State<MixedThemedDemo> createState() => _MixedThemedDemoState();
}

class _MixedThemedDemoState extends State<MixedThemedDemo> {
  late final FormController controller;

  @override
  void initState() {
    super.initState();
    controller = FormController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<DropdownItem>> fetchCountries({String? parentValue}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      DropdownItem(id: 'bd', label: 'Bangladesh'),
      DropdownItem(id: 'us', label: 'United States'),
      DropdownItem(id: 'uk', label: 'United Kingdom'),
    ];
  }

  List<FieldMeta> get fields => [
    FieldMeta.section(key: 'sec_profile', label: 'Profile Setup'),
    FieldMeta.custom(
      key: 'profile_image',
      label: 'Profile Photo',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            (isDark
                                    ? AppTheme.primaryLight
                                    : AppTheme.primaryColor)
                                .withValues(alpha: 0.2),
                            (isDark
                                    ? AppTheme.primaryLight
                                    : AppTheme.primaryColor)
                                .withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: isDark
                              ? AppTheme.darkBorder
                              : AppTheme.lightBorder,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: isDark
                            ? AppTheme.primaryLight
                            : AppTheme.primaryColor,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.primaryLight
                              : AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppTheme.darkSurface
                                : AppTheme.lightSurface,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Tap to upload photo',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTheme.darkTextHint
                      : AppTheme.lightTextHint,
                ),
              ),
            ),
          ],
        );
      },
    ),
    FieldMeta(
      key: 'full_name',
      label: 'Full Name',
      type: FieldType.text,
      required: true,
      hint: 'Enter your full name',
      validators: [RjValidators.required(), RjValidators.minLength(2)],
    ),
    FieldMeta(
      key: 'email',
      label: 'Email Address',
      type: FieldType.text,
      required: true,
      hint: 'you@example.com',
      validators: [RjValidators.required(), RjValidators.email()],
    ),
    FieldMeta.section(key: 'sec_details', label: 'Details'),
    FieldMeta(
      key: 'country',
      label: 'Country',
      type: FieldType.dropdown,
      required: true,
      hint: 'Select your country',
      dropdownSource: DropdownSource.async(fetchCountries),
    ),
    FieldMeta.custom(
      key: 'phone',
      label: 'Phone Number',
      required: true,
      validators: [PhoneValidators.byCountry()],
      builder: (context, field, value, onChanged, errorText) {
        final phone =
            value as PhoneNumber? ??
            PhoneNumber(countryCode: '+880', number: '');
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label}${field.required ? ' *' : ''}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkFieldFill
                        : AppTheme.lightFieldFill,
                    border: Border.all(
                      color: errorText != null
                          ? AppTheme.errorColor
                          : (isDark
                                ? AppTheme.darkBorder
                                : AppTheme.lightBorder),
                      width: AppTheme.borderWidth,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: phone.countryCode,
                      items: PhoneValidators.countryCodes.map((code) {
                        return DropdownMenuItem(value: code, child: Text(code));
                      }).toList(),
                      onChanged: (code) {
                        if (code != null) {
                          onChanged(
                            PhoneNumber(
                              countryCode: code,
                              number: phone.number,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      errorText: errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      onChanged(
                        PhoneNumber(
                          countryCode: phone.countryCode,
                          number: val,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
    FieldMeta.custom(
      key: 'rating',
      label: 'Experience Rating',
      required: true,
      validators: [
        (v) => (v == null || v == 0) ? 'Please rate your experience' : null,
      ],
      builder: (context, field, value, onChanged, errorText) {
        final rating = value as int? ?? 0;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label}${field.required ? ' *' : ''}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween(begin: 1.0, end: i < rating ? 1.15 : 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: IconButton(
                        icon: Icon(
                          i < rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: i < rating
                              ? AppTheme.accentColor
                              : (isDark
                                    ? AppTheme.darkTextHint
                                    : AppTheme.lightTextHint),
                          size: 36,
                        ),
                        onPressed: () => onChanged(i + 1),
                      ),
                    );
                  },
                );
              }),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  errorText,
                  style: const TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    ),
    FieldMeta.section(key: 'sec_preferences', label: 'Preferences'),
    FieldMeta(
      key: 'newsletter',
      label: 'Enable Notifications',
      type: FieldType.toggle,
      hint: 'Receive push notifications',
    ),
    FieldMeta.custom(
      key: 'interests',
      label: 'Interests',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final selected = value is List<String> ? value : <String>[];

        final interests = [
          {'id': 'tech', 'label': 'Technology', 'icon': Icons.computer_rounded},
          {'id': 'design', 'label': 'Design', 'icon': Icons.brush_rounded},
          {
            'id': 'business',
            'label': 'Business',
            'icon': Icons.business_center_rounded,
          },
          {'id': 'health', 'label': 'Health', 'icon': Icons.favorite_rounded},
          {'id': 'travel', 'label': 'Travel', 'icon': Icons.flight_rounded},
          {'id': 'food', 'label': 'Food', 'icon': Icons.restaurant_rounded},
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label}${field.required ? ' *' : ''}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((item) {
                final isSelected = selected.contains(item['id']);
                final icon = item['icon'] as IconData;
                return FilterChip(
                  avatar: Icon(icon, size: 18),
                  label: Text(item['label'] as String),
                  selected: isSelected,
                  onSelected: (val) {
                    final newSelected = List<String>.from(selected);
                    if (val) {
                      newSelected.add(item['id'] as String);
                    } else {
                      newSelected.remove(item['id']);
                    }
                    onChanged(newSelected);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    ),
    FieldMeta(
      key: 'satisfaction',
      label: 'Satisfaction Score',
      type: FieldType.slider,
      required: true,
      sliderMin: 0,
      sliderMax: 100,
      sliderDivisions: 100,
      sliderLabelBuilder: (val) => '${val.round()}%',
    ),
    FieldMeta.section(key: 'sec_info', label: 'Info'),
    FieldMeta.custom(
      key: 'app_version',
      label: 'App Version',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (isDark ? AppTheme.primaryLight : AppTheme.primaryColor)
                    .withValues(alpha: 0.08),
                (isDark ? AppTheme.primaryLight : AppTheme.primaryColor)
                    .withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: (isDark ? AppTheme.primaryLight : AppTheme.primaryColor)
                  .withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppTheme.primaryLight : AppTheme.primaryColor)
                          .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: isDark ? AppTheme.primaryLight : AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mixed & Themed Demo',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'v1.0.0 • Built with RJ Form Engine',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  ];

  Future<void> _handleSubmit(FormResult result) async {
    debugPrint('MIXED FORM RESULT: ${result.values}');
  }

  void _onSuccess(FormResult result) {
    _showResultDialog(result.values);
  }

  void _showResultDialog(Map<String, dynamic> values) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.successColor),
              SizedBox(width: 8),
              Text('Submitted'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: fields
                    .where((f) => f.type != FieldType.section)
                    .expand((f) {
                      final val = values[f.key];
                      if (val == null) return [const SizedBox.shrink()];
                      return [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatValue(f, val),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ];
                    })
                    .toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _formatValue(FieldMeta field, dynamic val) {
    if (val is DateTime) return RjTimeUtils.formatDate(val);
    if (val is TimeOfDay) return RjTimeUtils.format(val);
    if (val is List) return val.join(', ');
    if (val is bool) return val ? 'Yes' : 'No';
    if (val is PhoneNumber) return '${val.countryCode} ${val.number}';
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mixed & Themed'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              controller.clear();
              setState(() {});
              messengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('Form reset'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: RjForm(
                controller: controller,
                fields: fields,
                onSubmit: _handleSubmit,
                onSuccess: _onSuccess,
                autoClearOnSubmit: true,
                theme: RjFormTheme(
                  primaryColor: isDark
                      ? AppTheme.primaryLight
                      : AppTheme.primaryColor,
                  borderColor: isDark
                      ? AppTheme.darkBorder
                      : AppTheme.lightBorder,
                  errorColor: AppTheme.errorColor,
                  focusedBorderColor: isDark
                      ? AppTheme.primaryLight
                      : AppTheme.primaryColor,
                  fieldFillColor: isDark
                      ? AppTheme.darkFieldFill
                      : AppTheme.lightFieldFill,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  fieldSpacing: AppTheme.fieldSpacing,
                  borderWidth: AppTheme.borderWidth,
                  contentPadding: AppTheme.contentPadding,
                  submitButtonColor: isDark
                      ? AppTheme.primaryLight
                      : AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear_rounded),
                  label: const Text('Clear'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadius,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () {
                    if (controller.validate(fields)) {
                      final result = controller.toResult();
                      _showResultDialog(result.values);
                      controller.clear();
                      setState(() {});
                    } else {
                      messengerKey.currentState?.showSnackBar(
                        const SnackBar(
                          content: Text('Please fix validation errors'),
                          backgroundColor: AppTheme.errorColor,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Submit'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadius,
                      ),
                    ),
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
