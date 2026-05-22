import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

class DefaultFieldsDemo extends StatefulWidget {
  const DefaultFieldsDemo({super.key});

  @override
  State<DefaultFieldsDemo> createState() => _DefaultFieldsDemoState();
}

class _DefaultFieldsDemoState extends State<DefaultFieldsDemo> {
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
    FieldMeta.section(key: 'sec_account', label: 'Account'),
    // Full Name + Email — side by side on tablet+
    FieldMeta.text(
      key: 'full_name',
      label: 'Full Name',
      required: true,
      hint: 'Enter your full name',
      validators: [RjValidators.required(), RjValidators.minLength(2)],
      layout: const RjLayout(md: RjSpan.half),
    ),
    FieldMeta.text(
      key: 'email',
      label: 'Email Address',
      required: true,
      hint: 'you@example.com',
      validators: [RjValidators.required(), RjValidators.email()],
      layout: const RjLayout(md: RjSpan.half),
    ),
    // Password — full width (security field, should stand alone)
    FieldMeta.text(
      key: 'password',
      label: 'Password',
      required: true,
      obscureText: true,
      hint: 'Min 8 characters',
      validators: [
        RjValidators.required(),
        RjValidators.minLength(8),
        RjValidators.hasUppercase(),
        RjValidators.hasDigit(),
      ],
    ),
    // Bio — full width (textarea needs space)
    FieldMeta.textArea(
      key: 'bio',
      label: 'Bio',
      hint: 'Tell us about yourself...',
      maxLines: 4,
      validators: [RjValidators.maxLength(500)],
    ),
    FieldMeta.section(key: 'sec_profile', label: 'Profile'),
    // Age + DOB — side by side
    FieldMeta.number(
      key: 'age',
      label: 'Age',
      required: true,
      hint: 'Enter your age',
      validators: [RjValidators.required(), RjValidators.between(1, 150)],
      layout: const RjLayout(md: RjSpan.half),
    ),
    FieldMeta.date(
      key: 'dob',
      label: 'Date of Birth',
      required: true,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      hint: 'Select your date of birth',
      layout: const RjLayout(md: RjSpan.half),
    ),
    // Preferred Time + Country — side by side
    FieldMeta.timePicker(
      key: 'preferred_time',
      label: 'Preferred Time',
      required: true,
      hint: 'Select a time',
      layout: const RjLayout(md: RjSpan.half),
    ),
    FieldMeta.dropdown(
      key: 'country',
      label: 'Country',
      required: true,
      hint: 'Select your country',
      dropdownSource: DropdownSource.async(fetchCountries),
      layout: const RjLayout(md: RjSpan.half),
    ),
    // Gender — full width (radio options need horizontal space)
    FieldMeta.radio(
      key: 'gender',
      label: 'Gender',
      required: true,
      options: [
        DropdownItem(id: 'male', label: 'Male'),
        DropdownItem(id: 'female', label: 'Female'),
        DropdownItem(id: 'non_binary', label: 'Non-Binary'),
        DropdownItem(id: 'prefer_not', label: 'Prefer not to say'),
      ],
    ),
    FieldMeta.section(key: 'sec_settings', label: 'Settings'),
    FieldMeta.toggle(
      key: 'newsletter',
      label: 'Subscribe to Newsletter',
      hint: 'Get weekly updates',
    ),
    // Skills + Satisfaction — side by side
    FieldMeta.chip(
      key: 'skills',
      label: 'Skills',
      required: true,
      hint: 'Select all that apply',
      options: [
        DropdownItem(id: 'dart', label: 'Dart'),
        DropdownItem(id: 'flutter', label: 'Flutter'),
        DropdownItem(id: 'firebase', label: 'Firebase'),
        DropdownItem(id: 'rest_api', label: 'REST API'),
        DropdownItem(id: 'git', label: 'Git'),
      ],
      layout: const RjLayout(md: RjSpan.half),
    ),
    FieldMeta.slider(
      key: 'satisfaction',
      label: 'Satisfaction',
      required: true,
      sliderMin: 0,
      sliderMax: 100,
      sliderDivisions: 100,
      sliderLabelBuilder: (val) => '${val.round()}%',
      layout: const RjLayout(md: RjSpan.half),
    ),
    // Volume + Quantity — side by side
    FieldMeta.slider(
      key: 'volume',
      label: 'Volume',
      sliderMin: 0,
      sliderMax: 10,
      sliderDivisions: 10,
      sliderLabelBuilder: (val) => '${val.round()}',
      layout: const RjLayout(md: RjSpan.half),
    ),
    FieldMeta.spinner(
      key: 'quantity',
      label: 'Quantity',
      required: true,
      spinnerMin: 1,
      spinnerMax: 99,
      spinnerStep: 1,
      layout: const RjLayout(md: RjSpan.half),
    ),
    FieldMeta.section(key: 'sec_media', label: 'Media'),
    FieldMeta.image(
      key: 'profile_images',
      label: 'Profile Images',
      maxImages: 5,
      hint: 'Upload up to 5 images',
    ),
  ];

  Future<void> _handleSubmit(FormResult result) async {
    debugPrint('DEFAULT FORM RESULT: ${result.values}');
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
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Fields'),
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
