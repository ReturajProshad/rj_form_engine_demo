import 'package:rj_form_engine/rj_form_engine.dart';

class PhoneNumber {
  final String countryCode; // +880
  final String number; // 1712345678

  PhoneNumber({required this.countryCode, required this.number});

  String get full => '$countryCode$number';
}

class PhoneValidators {
  static const countryCodes = ['+880', '+91', '+1'];

  static final Map<String, RegExp> _rules = {
    '+880': RegExp(r'^1[3-9]\d{8}$'), // Bangladesh
    '+91': RegExp(r'^[6-9]\d{9}$'), // India
    '+1': RegExp(r'^\d{10}$'), // USA
  };

  static FieldValidator byCountry() {
    return (val) {
      if (val == null || val is! PhoneNumber) {
        return 'Phone number required';
      }

      final rule = _rules[val.countryCode];

      if (rule == null) {
        return 'Unsupported country';
      }

      if (!rule.hasMatch(val.number)) {
        return 'Invalid phone number for ${val.countryCode}';
      }

      return null;
    };
  }
}
