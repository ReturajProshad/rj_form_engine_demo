import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/phone_number.dart';

class FormDemoPage extends StatefulWidget {
  const FormDemoPage({super.key});

  @override
  State<FormDemoPage> createState() => _FormDemoPageState();
}

class _FormDemoPageState extends State<FormDemoPage> {
  late final FormController controller;

  @override
  void initState() {
    super.initState();
    controller = FormController();
  }

  // ------------------------------
  // Mock APIs — updated to new DropdownLoader signature
  // ------------------------------

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

  // ------------------------------
  // Fields — ALL 13 built-in types + custom + section
  // ------------------------------
  List<FieldMeta> get fields => [
    // Sections now require explicit key
    FieldMeta.section(key: 'sec_personal', label: 'Personal Info'),

    FieldMeta(key: 'full_name', label: 'Full Name', type: FieldType.text, required: true, hint: 'Enter your full name', validators: [RjValidators.required(), RjValidators.minLength(2)]),

    FieldMeta(key: 'email', label: 'Email Address', type: FieldType.text, required: true, hint: 'you@example.com', validators: [RjValidators.required(), RjValidators.email()]),

    FieldMeta(
      key: 'password',
      label: 'Password',
      type: FieldType.text,
      required: true,
      obscureText: true,
      hint: 'Enter your password',
      validators: [RjValidators.required(), RjValidators.minLength(8), RjValidators.hasUppercase(), RjValidators.hasDigit()],
    ),

    FieldMeta(key: 'bio', label: 'Bio', type: FieldType.textArea, hint: 'Tell us about yourself...', maxLines: 4, validators: [RjValidators.maxLength(500)]),

    FieldMeta(key: 'age', label: 'Age', type: FieldType.number, required: true, hint: 'Enter your age', validators: [RjValidators.required(), RjValidators.between(1, 150)]),

    FieldMeta(key: 'dob', label: 'Date of Birth', type: FieldType.date, required: true, firstDate: DateTime(1900), lastDate: DateTime.now(), hint: 'Select your date of birth'),

    FieldMeta.section(key: 'sec_scheduling', label: 'Scheduling'),

    FieldMeta(key: 'preferred_time', label: 'Preferred Meeting Time', type: FieldType.timePicker, required: true, hint: 'Select a time'),

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
      // Removed flat dependsOn — only dependency now
      dependency: FieldDependency(dependsOn: 'country', condition: (val) => val != null),
      hint: 'Select your city',
      dropdownSource: DropdownSource.async(fetchCities),
    ),

    FieldMeta.section(key: 'sec_preferences', label: 'Preferences'),

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

    // CustomFieldBuilder now receives `field` as 2nd param
    FieldMeta.custom(
      key: 'phone',
      label: 'Phone Number',
      required: true,
      validators: [PhoneValidators.byCountry()],
      builder: (context, field, value, onChanged, errorText) {
        final phone = value as PhoneNumber? ?? PhoneNumber(countryCode: '+880', number: '');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label}${field.required ? ' *' : ''}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
            ),
            if (field.hint != null) Text(field.hint!, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
            const SizedBox(height: 8),
            Row(
              children: [
                DropdownButton<String>(
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
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      errorText: errorText,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label}${field.required ? ' *' : ''}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                return IconButton(
                  icon: Icon(i < rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 36),
                  onPressed: () => onChanged(i + 1),
                );
              }),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(errorText, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12)),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          maxLines: 3,
          onChanged: onChanged,
        );
      },
    ),

    FieldMeta.custom(
      key: 'app_version',
      label: 'App Version',
      builder: (context, field, value, onChanged, errorText) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF6B7280)),
              SizedBox(width: 12),
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 14, color: Color(0xFF374151), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    ),
  ];

  // ------------------------------
  // Submit handler
  // ------------------------------
  Future<void> _handleSubmit(FormResult result) async {
    debugPrint('FORM RESULT: ${result.values}');
  }

  void _onSuccess(FormResult result) {
    _showResultDialog(result.values);
  }

  void _showResultDialog(Map<String, dynamic> values) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Form Submitted'),
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(f.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(flex: 3, child: Text(display, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ),
                  ];
                }).toList(),
              ),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
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
    return val.toString();
  }

  // ------------------------------
  // UI
  // ------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RJ Form Engine — All Fields'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.clear();
              setState(() {});
            },
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: RjForm(controller: controller, fields: fields, onSubmit: _handleSubmit, onSuccess: _onSuccess, autoClearOnSubmit: true),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (controller.validate(fields)) {
            final result = controller.toResult();
            debugPrint('MANUAL SUBMIT: ${result.values}');
            _showResultDialog(result.values);
            controller.clear();
            setState(() {});
          } else {
            messengerKey.currentState?.showSnackBar(const SnackBar(content: Text('Please fix validation errors'), backgroundColor: Colors.red));
          }
        },
        label: const Text('Submit'),
        icon: const Icon(Icons.send),
      ),
    );
  }
}
