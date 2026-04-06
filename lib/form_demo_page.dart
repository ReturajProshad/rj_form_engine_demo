import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/phone_number.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

class FormDemoPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const FormDemoPage({super.key, required this.onToggleTheme, required this.themeMode});

  @override
  State<FormDemoPage> createState() => _FormDemoPageState();
}

class _FormDemoPageState extends State<FormDemoPage> {
  late final FormController controller;
  final _scrollKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false;

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
    await Future.delayed(const Duration(milliseconds: 500));
    return [DropdownItem(id: 'bd', label: 'Bangladesh'), DropdownItem(id: 'us', label: 'United States'), DropdownItem(id: 'in', label: 'India'), DropdownItem(id: 'uk', label: 'United Kingdom')];
  }

  Future<List<DropdownItem>> fetchCities({String? parentValue}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (parentValue == 'bd') {
      return [DropdownItem(id: 'dhaka', label: 'Dhaka'), DropdownItem(id: 'ctg', label: 'Chattogram'), DropdownItem(id: 'sylhet', label: 'Sylhet')];
    } else if (parentValue == 'us') {
      return [DropdownItem(id: 'ny', label: 'New York'), DropdownItem(id: 'sf', label: 'San Francisco'), DropdownItem(id: 'la', label: 'Los Angeles')];
    } else if (parentValue == 'in') {
      return [DropdownItem(id: 'mumbai', label: 'Mumbai'), DropdownItem(id: 'delhi', label: 'Delhi'), DropdownItem(id: 'bangalore', label: 'Bangalore')];
    } else if (parentValue == 'uk') {
      return [DropdownItem(id: 'london', label: 'London'), DropdownItem(id: 'manchester', label: 'Manchester'), DropdownItem(id: 'birmingham', label: 'Birmingham')];
    }
    return [];
  }

  List<FieldMeta> get fields => [
    FieldMeta.section(key: 'sec_personal', label: 'Personal Information'),
    FieldMeta(key: 'full_name', label: 'Full Name', type: FieldType.text, required: true, hint: 'Enter your full name', validators: [RjValidators.required(), RjValidators.minLength(2)]),
    FieldMeta(key: 'email', label: 'Email Address', type: FieldType.text, required: true, hint: 'you@example.com', validators: [RjValidators.required(), RjValidators.email()]),
    FieldMeta(
      key: 'password',
      label: 'Password',
      type: FieldType.text,
      required: true,
      obscureText: true,
      hint: 'Min 8 characters',
      validators: [RjValidators.required(), RjValidators.minLength(8), RjValidators.hasUppercase(), RjValidators.hasDigit()],
    ),
    FieldMeta(key: 'bio', label: 'Bio', type: FieldType.textArea, hint: 'Tell us about yourself...', maxLines: 4, validators: [RjValidators.maxLength(500)]),
    FieldMeta(key: 'age', label: 'Age', type: FieldType.number, required: true, hint: 'Enter your age', validators: [RjValidators.required(), RjValidators.between(1, 150)]),
    FieldMeta(key: 'dob', label: 'Date of Birth', type: FieldType.date, required: true, firstDate: DateTime(1900), lastDate: DateTime.now(), hint: 'Select your date of birth'),
    FieldMeta.section(key: 'sec_scheduling', label: 'Scheduling'),
    FieldMeta(key: 'preferred_time', label: 'Preferred Meeting Time', type: FieldType.timePicker, required: true, hint: 'Select a time'),
    FieldMeta.section(key: 'sec_preferences', label: 'Preferences'),
    FieldMeta(
      key: 'gender',
      label: 'Gender',
      type: FieldType.dropdown,
      required: true,
      dropdownSource: DropdownSource.static([
        DropdownItem(id: 'male', label: 'Male'),
        DropdownItem(id: 'female', label: 'Female'),
        DropdownItem(id: 'non_binary', label: 'Non-Binary'),
        DropdownItem(id: 'prefer_not', label: 'Prefer not to say'),
      ]),
    ),
    FieldMeta(key: 'country', label: 'Country', type: FieldType.dropdown, required: true, hint: 'Select your country', dropdownSource: DropdownSource.async(fetchCountries)),
    FieldMeta(
      key: 'city',
      label: 'City',
      type: FieldType.dropdown,
      required: true,
      dependency: FieldDependency(dependsOn: 'country', condition: (val) => val != null),
      hint: 'Select your city',
      dropdownSource: DropdownSource.async(fetchCities),
    ),
    FieldMeta(key: 'newsletter', label: 'Subscribe to Newsletter', type: FieldType.toggle, hint: 'Get weekly updates and news'),
    FieldMeta(key: 'accept_terms', label: 'Accept Terms & Conditions', type: FieldType.toggle, required: true, hint: 'You must accept to continue'),
    FieldMeta(
      key: 'experience_level',
      label: 'Experience Level',
      type: FieldType.radio,
      required: true,
      options: [
        DropdownItem(id: 'beginner', label: 'Beginner', sublabel: 'Less than 1 year'),
        DropdownItem(id: 'intermediate', label: 'Intermediate', sublabel: '1-3 years'),
        DropdownItem(id: 'advanced', label: 'Advanced', sublabel: '3-5 years'),
        DropdownItem(id: 'expert', label: 'Expert', sublabel: '5+ years'),
      ],
    ),
    FieldMeta(
      key: 'skills',
      label: 'Skills',
      type: FieldType.chip,
      required: true,
      hint: 'Select all that apply',
      options: [
        DropdownItem(id: 'dart', label: 'Dart'),
        DropdownItem(id: 'flutter', label: 'Flutter'),
        DropdownItem(id: 'firebase', label: 'Firebase'),
        DropdownItem(id: 'rest_api', label: 'REST API'),
        DropdownItem(id: 'git', label: 'Git'),
        DropdownItem(id: 'figma', label: 'Figma'),
        DropdownItem(id: 'sql', label: 'SQL'),
        DropdownItem(id: 'aws', label: 'AWS'),
      ],
    ),
    FieldMeta.section(key: 'sec_ratings', label: 'Ratings & Quantities'),
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
    FieldMeta(key: 'volume', label: 'Volume Level', type: FieldType.slider, sliderMin: 0, sliderMax: 10, sliderDivisions: 10, sliderLabelBuilder: (val) => '${val.round()}'),
    FieldMeta(key: 'quantity', label: 'Quantity', type: FieldType.spinner, required: true, spinnerMin: 1, spinnerMax: 99, spinnerStep: 1),
    FieldMeta(key: 'years_experience', label: 'Years of Experience', type: FieldType.spinner, spinnerMin: 0, spinnerMax: 50, spinnerStep: 5),
    FieldMeta.section(key: 'sec_media', label: 'Media & Custom'),
    FieldMeta(key: 'profile_images', label: 'Profile Images', type: FieldType.image, maxImages: 5, hint: 'Upload up to 5 images'),
    FieldMeta.custom(
      key: 'phone',
      label: 'Phone Number',
      required: true,
      validators: [PhoneValidators.byCountry()],
      builder: (context, field, value, onChanged, errorText) {
        final phone = value as PhoneNumber? ?? PhoneNumber(countryCode: '+880', number: '');
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${field.label}${field.required ? ' *' : ''}',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                ),
              ],
            ),
            if (field.hint != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(field.hint!, style: theme.textTheme.bodySmall?.copyWith(color: isDark ? AppTheme.darkTextHint : AppTheme.lightTextHint)),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkFieldFill : AppTheme.lightFieldFill,
                    border: Border.all(
                      color: errorText != null
                          ? AppTheme.errorColor
                          : isDark
                          ? AppTheme.darkBorder
                          : AppTheme.lightBorder,
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
                          onChanged(PhoneNumber(countryCode: code, number: phone.number));
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
                    ),
                    onChanged: (val) {
                      onChanged(PhoneNumber(countryCode: phone.countryCode, number: val));
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
      label: 'Rate Your Experience',
      required: true,
      validators: [(v) => (v == null || v == 0) ? 'Please rate your experience' : null],
      builder: (context, field, value, onChanged, errorText) {
        final rating = value as int? ?? 0;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${field.label}${field.required ? ' *' : ''}',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween(begin: 1.0, end: i < rating ? 1.2 : 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: IconButton(
                        icon: Icon(
                          i < rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: i < rating ? AppTheme.accentColor : (isDark ? AppTheme.darkTextHint : AppTheme.lightTextHint),
                          size: 40,
                        ),
                        onPressed: () => onChanged(i + 1),
                      ),
                    );
                  },
                );
              }),
            ),
            if (rating > 0)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  rating <= 2
                      ? 'Poor'
                      : rating == 3
                      ? 'Average'
                      : rating == 4
                      ? 'Good'
                      : 'Excellent',
                  style: theme.textTheme.bodySmall?.copyWith(color: rating <= 2 ? AppTheme.errorColor : AppTheme.successColor, fontWeight: FontWeight.w500),
                ),
              ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(errorText, style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.errorColor)),
              ),
          ],
        );
      },
    ),
    FieldMeta.custom(
      key: 'feedback',
      label: 'Feedback',
      dependency: FieldDependency(dependsOn: 'rating', condition: (val) => (val ?? 0) < 3),
      builder: (context, field, value, onChanged, errorText) {
        return TextField(
          decoration: InputDecoration(
            labelText: 'Tell us what went wrong',
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
          ),
          maxLines: 3,
          onChanged: onChanged,
        );
      },
    ),
    FieldMeta.custom(
      key: 'color_preference',
      label: 'Favorite Color',
      builder: (context, field, value, onChanged, errorText) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final selectedColor = value as Color?;

        final colors = [Colors.red, Colors.orange, Colors.amber, Colors.green, Colors.teal, Colors.blue, Colors.indigo, Colors.purple, Colors.pink, Colors.brown];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${field.label}${field.required ? ' *' : ''}',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((color) {
                final isSelected = selectedColor == color;
                return GestureDetector(
                  onTap: () => onChanged(isSelected ? null : color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary) : Colors.transparent, width: 2.5),
                      boxShadow: isSelected ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2)] : null,
                    ),
                    child: isSelected ? Icon(Icons.check_rounded, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white, size: 24) : null,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    ),
    FieldMeta.custom(
      key: 'tags',
      label: 'Tags',
      builder: (context, field, value, onChanged, errorText) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final tags = value is List<String> ? value : <String>[];
        final controller = TextEditingController();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${field.label}${field.required ? ' *' : ''}',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...tags.map(
                  (tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close_rounded, size: 18),
                    onDeleted: () {
                      final newTags = List<String>.from(tags)..remove(tag);
                      onChanged(newTags);
                    },
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Add tag...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        final newTags = List<String>.from(tags)..add(val.trim());
                        onChanged(newTags);
                        controller.clear();
                      }
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
      key: 'app_version',
      label: 'App Version',
      builder: (context, field, value, onChanged, errorText) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder, width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Version 1.0.0 • Build 2026.04.06',
                  style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ];

  // Future<void> _handleSubmit(FormResult result) async {
  //   debugPrint('FORM RESULT: ${result.values}');
  // }

  void _onSuccess(FormResult result) {
    _showResultDialog(result.values);
  }

  void _showResultDialog(Map<String, dynamic> values) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.successColor),
              SizedBox(width: 8),
              Text('Form Submitted'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: fields.where((f) => f.type != FieldType.section && (f.dependency == null || f.dependency!.isVisible(values))).expand((f) {
                  final val = values[f.key];
                  if (val == null) return [const SizedBox.shrink()];
                  final display = _formatValue(f, val);
                  return [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(display, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ];
                }).toList(),
              ),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
        );
      },
    );
  }

  String _formatValue(FieldMeta field, dynamic val) {
    if (val is DateTime) {
      return RjTimeUtils.formatDate(val);
    }
    if (val is TimeOfDay) {
      return RjTimeUtils.format(val);
    }
    if (val is List) {
      return val.join(', ');
    }
    if (val is bool) {
      return val ? 'Yes' : 'No';
    }
    if (val is PhoneNumber) {
      return '${val.countryCode} ${val.number}';
    }
    if (val is Color) {
      return '#${val.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
    }
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scrollKey,
      appBar: AppBar(
        title: const Text('Form Engine Demo'),
        leading: IconButton(icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded), onPressed: widget.onToggleTheme, tooltip: 'Toggle theme'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              controller.clear();
              setState(() {});
              messengerKey.currentState?.showSnackBar(const SnackBar(content: Text('Form reset'), duration: Duration(seconds: 1)));
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
                // onSubmit: _handleSubmit,
                onSuccess: _onSuccess,
                autoClearOnSubmit: true,
                theme: RjFormTheme(
                  primaryColor: isDark ? AppTheme.primaryLight : AppTheme.primaryColor,
                  borderColor: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  errorColor: AppTheme.errorColor,
                  focusedBorderColor: isDark ? AppTheme.primaryLight : AppTheme.primaryColor,
                  fieldFillColor: isDark ? AppTheme.darkFieldFill : AppTheme.lightFieldFill,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  fieldSpacing: AppTheme.fieldSpacing,
                  borderWidth: AppTheme.borderWidth,
                  contentPadding: AppTheme.contentPadding,
                  submitButtonColor: isDark ? AppTheme.primaryLight : AppTheme.primaryColor,
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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          setState(() => _isSubmitting = true);
                          if (controller.validate(fields)) {
                            final result = controller.toResult();
                            debugPrint('MANUAL SUBMIT: ${result.values}');
                            _showResultDialog(result.values);
                            controller.clear();
                            setState(() {});
                          } else {
                            messengerKey.currentState?.showSnackBar(const SnackBar(content: Text('Please fix validation errors'), backgroundColor: AppTheme.errorColor));
                          }
                          setState(() => _isSubmitting = false);
                        },
                  icon: _isSubmitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send_rounded),
                  label: Text(_isSubmitting ? 'Submitting...' : 'Submit Form'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
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
