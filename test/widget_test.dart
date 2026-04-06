import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/phone_number.dart';
import 'package:rj_form_engine_tests_project/screens/default_fields_demo.dart';
import 'package:rj_form_engine_tests_project/screens/custom_fields_demo.dart';
import 'package:rj_form_engine_tests_project/screens/mixed_themed_demo.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpApp(WidgetTester tester, {Widget? home}) async {
    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: messengerKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home:
            home ??
            HomeScreenWrapper(onToggleTheme: () {}, themeMode: ThemeMode.light),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpDefaultDemo(WidgetTester tester) async {
    await pumpApp(tester, home: const DefaultFieldsDemo());
  }

  Future<void> pumpCustomDemo(WidgetTester tester) async {
    await pumpApp(tester, home: const CustomFieldsDemo());
  }

  Future<void> pumpMixedDemo(WidgetTester tester) async {
    await pumpApp(tester, home: const MixedThemedDemo());
  }

  group('AppTheme', () {
    test('light theme has correct brightness', () {
      expect(AppTheme.lightTheme.brightness, Brightness.light);
    });

    test('dark theme has correct brightness', () {
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
    });

    test('theme constants are defined', () {
      expect(AppTheme.primaryColor, const Color(0xFF4F46E5));
      expect(AppTheme.accentColor, const Color(0xFFF59E0B));
      expect(AppTheme.successColor, const Color(0xFF10B981));
      expect(AppTheme.errorColor, const Color(0xFFEF4444));
    });
  });

  group('PhoneNumber', () {
    test('full getter returns correct format', () {
      final phone = PhoneNumber(countryCode: '+880', number: '1712345678');
      expect(phone.full, '+8801712345678');
    });

    test('PhoneValidators validates Bangladesh number', () {
      final validator = PhoneValidators.byCountry();
      final validPhone = PhoneNumber(countryCode: '+880', number: '1712345678');
      final invalidPhone = PhoneNumber(countryCode: '+880', number: '123');

      expect(validator(validPhone), isNull);
      expect(validator(invalidPhone), isNotNull);
    });

    test('PhoneValidators validates India number', () {
      final validator = PhoneValidators.byCountry();
      final validPhone = PhoneNumber(countryCode: '+91', number: '9876543210');
      final invalidPhone = PhoneNumber(countryCode: '+91', number: '123');

      expect(validator(validPhone), isNull);
      expect(validator(invalidPhone), isNotNull);
    });

    test('PhoneValidators validates USA number', () {
      final validator = PhoneValidators.byCountry();
      final validPhone = PhoneNumber(countryCode: '+1', number: '1234567890');
      final invalidPhone = PhoneNumber(countryCode: '+1', number: '123');

      expect(validator(validPhone), isNull);
      expect(validator(invalidPhone), isNotNull);
    });

    test('PhoneValidators returns error for null value', () {
      final validator = PhoneValidators.byCountry();
      expect(validator(null), isNotNull);
    });

    test('PhoneValidators returns error for non-PhoneNumber type', () {
      final validator = PhoneValidators.byCountry();
      expect(validator('not a phone'), isNotNull);
    });
  });

  group('HomeScreen', () {
    testWidgets('renders app title', (tester) async {
      await pumpApp(tester);
      expect(find.text('RJ Form Engine'), findsOneWidget);
    });

    testWidgets('renders theme toggle button', (tester) async {
      await pumpApp(tester);
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    });

    testWidgets('renders three demo cards', (tester) async {
      await pumpApp(tester);
      expect(find.text('Default Fields & Style'), findsOneWidget);
      expect(find.text('Custom Fields Only'), findsOneWidget);
      expect(find.text('Mixed Fields with Custom Theme'), findsOneWidget);
    });

    testWidgets('renders version text', (tester) async {
      await pumpApp(tester);
      expect(find.text('v1.0.0'), findsOneWidget);
    });

    testWidgets('tapping Default Fields card navigates', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Default Fields & Style'));
      await tester.pumpAndSettle();
      expect(find.text('Default Fields'), findsOneWidget);
    });

    testWidgets('tapping Custom Fields card navigates', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Custom Fields Only'));
      await tester.pumpAndSettle();
      expect(find.text('Custom Fields'), findsOneWidget);
    });

    testWidgets('tapping Mixed Fields card navigates', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Mixed Fields with Custom Theme'));
      await tester.pumpAndSettle();
      expect(find.text('Mixed & Themed'), findsOneWidget);
    });
  });

  group('DefaultFieldsDemo', () {
    testWidgets('renders AppBar with title', (tester) async {
      await pumpDefaultDemo(tester);
      expect(find.text('Default Fields'), findsOneWidget);
    });

    testWidgets('renders section headers', (tester) async {
      await pumpDefaultDemo(tester);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Media'), findsOneWidget);
    });

    testWidgets('renders Clear and Submit buttons', (tester) async {
      await pumpDefaultDemo(tester);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('renders reset button', (tester) async {
      await pumpDefaultDemo(tester);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    });

    testWidgets('reset button shows snackbar', (tester) async {
      await pumpDefaultDemo(tester);
      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Form reset'), findsOneWidget);
    });

    testWidgets('back button exists', (tester) async {
      await pumpDefaultDemo(tester);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });
  });

  group('CustomFieldsDemo', () {
    testWidgets('renders AppBar with title', (tester) async {
      await pumpCustomDemo(tester);
      expect(find.text('Custom Fields'), findsOneWidget);
    });

    testWidgets('renders custom section headers', (tester) async {
      await pumpCustomDemo(tester);
      expect(find.text('Rating & Feedback'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Custom Selection'), findsOneWidget);
    });

    testWidgets('renders star rating icons', (tester) async {
      await pumpCustomDemo(tester);
      expect(find.byIcon(Icons.star_border_rounded), findsWidgets);
    });

    testWidgets('renders Clear and Submit buttons', (tester) async {
      await pumpCustomDemo(tester);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });
  });

  group('MixedThemedDemo', () {
    testWidgets('renders AppBar with title', (tester) async {
      await pumpMixedDemo(tester);
      expect(find.text('Mixed & Themed'), findsOneWidget);
    });

    testWidgets('renders section headers', (tester) async {
      await pumpMixedDemo(tester);
      expect(find.text('Profile Setup'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Info'), findsOneWidget);
    });

    testWidgets('renders Clear and Submit buttons', (tester) async {
      await pumpMixedDemo(tester);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('renders profile photo placeholder', (tester) async {
      await pumpMixedDemo(tester);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });
  });

  group('FormController integration', () {
    testWidgets('can set and retrieve values', (tester) async {
      final controller = FormController();

      controller.setValue('full_name', 'John Doe');
      expect(controller.values['full_name'], 'John Doe');

      controller.setValue('age', 25);
      expect(controller.values['age'], 25);

      controller.dispose();
    });

    testWidgets('validation catches required fields', (tester) async {
      final controller = FormController();
      final fields = [
        FieldMeta(
          key: 'name',
          label: 'Name',
          type: FieldType.text,
          required: true,
          validators: [RjValidators.required()],
        ),
      ];

      expect(controller.validate(fields), isFalse);

      controller.setValue('name', 'John');
      expect(controller.validate(fields), isTrue);

      controller.dispose();
    });

    testWidgets('FormResult returns correct values', (tester) async {
      final controller = FormController();
      controller.setValue('name', 'John');
      controller.setValue('age', 30);

      final result = controller.toResult();
      expect(result.values['name'], 'John');
      expect(result.values['age'], 30);

      controller.dispose();
    });
  });

  group('RjFormTheme customization', () {
    testWidgets('custom theme is applied to form', (tester) async {
      final controller = FormController();
      final fields = [
        FieldMeta(key: 'test', label: 'Test Field', type: FieldType.text),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RjForm(
              controller: controller,
              fields: fields,
              onSubmit: (_) async {},
              theme: const RjFormTheme(
                primaryColor: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Field'), findsOneWidget);

      controller.dispose();
    });
  });

  group('FieldMeta configurations', () {
    test('section field has correct type', () {
      final section = FieldMeta.section(
        key: 'test_section',
        label: 'Test Section',
      );
      expect(section.type, FieldType.section);
      expect(section.label, 'Test Section');
    });

    test('custom field has builder', () {
      final custom = FieldMeta.custom(
        key: 'custom_field',
        label: 'Custom',
        builder: (context, field, value, onChanged, errorText) {
          return const SizedBox.shrink();
        },
      );
      expect(custom.type, FieldType.custom);
      expect(custom.builder, isNotNull);
    });

    test('field with dependency has correct config', () {
      final field = FieldMeta(
        key: 'child',
        label: 'Child',
        type: FieldType.dropdown,
        dependency: FieldDependency(
          dependsOn: 'parent',
          condition: (val) => val != null,
        ),
      );
      expect(field.dependency, isNotNull);
      expect(field.dependency!.dependsOn, 'parent');
    });
  });

  group('DropdownSource', () {
    test('static source returns items immediately', () async {
      final source = DropdownSource.static([
        DropdownItem(id: 'a', label: 'A'),
        DropdownItem(id: 'b', label: 'B'),
      ]);

      final items = await source.resolve(parentValue: null);
      expect(items.length, 2);
      expect(items[0].label, 'A');
    });

    test('async source calls loader function', () async {
      Future<List<DropdownItem>> mockLoader({String? parentValue}) async {
        return [DropdownItem(id: 'x', label: 'X')];
      }

      final source = DropdownSource.async(mockLoader);
      final items = await source.resolve(parentValue: null);
      expect(items.length, 1);
      expect(items[0].label, 'X');
    });
  });

  group('RjValidators', () {
    test('required validator', () {
      final validator = RjValidators.required();
      expect(validator(null), isNotNull);
      expect(validator(''), isNotNull);
      expect(validator('   '), isNotNull);
      expect(validator('valid'), isNull);
    });

    test('email validator', () {
      final validator = RjValidators.email();
      expect(validator('invalid'), isNotNull);
      expect(validator('test@example.com'), isNull);
    });

    test('minLength validator', () {
      final validator = RjValidators.minLength(3);
      expect(validator('ab'), isNotNull);
      expect(validator('abc'), isNull);
    });

    test('maxLength validator', () {
      final validator = RjValidators.maxLength(5);
      expect(validator('abcdef'), isNotNull);
      expect(validator('abc'), isNull);
    });

    test('min validator for numbers', () {
      final validator = RjValidators.min(10);
      expect(validator(5), isNotNull);
      expect(validator(10), isNull);
      expect(validator(15), isNull);
    });

    test('max validator for numbers', () {
      final validator = RjValidators.max(10);
      expect(validator(15), isNotNull);
      expect(validator(10), isNull);
      expect(validator(5), isNull);
    });

    test('hasUppercase validator', () {
      final validator = RjValidators.hasUppercase();
      expect(validator('lowercase'), isNotNull);
      expect(validator('UpperCase'), isNull);
    });

    test('hasDigit validator', () {
      final validator = RjValidators.hasDigit();
      expect(validator('nodigits'), isNotNull);
      expect(validator('has1digit'), isNull);
    });

    test('pastDate validator', () {
      final validator = RjValidators.pastDate();
      expect(
        validator(DateTime.now().subtract(const Duration(days: 1))),
        isNull,
      );
      expect(validator(DateTime.now().add(const Duration(days: 1))), isNotNull);
    });

    test('futureDate validator', () {
      final validator = RjValidators.futureDate();
      expect(validator(DateTime.now().add(const Duration(days: 1))), isNull);
      expect(
        validator(DateTime.now().subtract(const Duration(days: 1))),
        isNotNull,
      );
    });
  });

  group('RjTimeUtils', () {
    test('formatDate returns formatted string', () {
      final date = DateTime(2026, 4, 6);
      final formatted = RjTimeUtils.formatDate(date);
      expect(formatted, isA<String>());
      expect(formatted.isNotEmpty, isTrue);
    });

    test('format TimeOfDay returns formatted string', () {
      final time = const TimeOfDay(hour: 14, minute: 30);
      final formatted = RjTimeUtils.format(time);
      expect(formatted, isA<String>());
      expect(formatted.isNotEmpty, isTrue);
    });
  });

  group('FormController advanced', () {
    testWidgets('setValueAndClearDependents clears dependent fields', (
      tester,
    ) async {
      final controller = FormController();
      final fields = [
        FieldMeta(key: 'country', label: 'Country', type: FieldType.dropdown),
        FieldMeta(
          key: 'city',
          label: 'City',
          type: FieldType.dropdown,
          dependency: FieldDependency(
            dependsOn: 'country',
            condition: (val) => val != null,
          ),
        ),
      ];

      controller.setValue('country', 'bd');
      controller.setValue('city', 'dhaka');

      controller.setValueAndClearDependents('country', 'us', fields);

      expect(controller.values['country'], 'us');
      expect(controller.values['city'], isNull);

      controller.dispose();
    });

    testWidgets('isDirty tracks changes', (tester) async {
      final controller = FormController();

      expect(controller.isDirty, isFalse);

      controller.setValue('name', 'John');
      expect(controller.isDirty, isTrue);

      controller.clear();
      expect(controller.isDirty, isFalse);

      controller.dispose();
    });

    testWidgets('clearErrors removes all errors', (tester) async {
      final controller = FormController();

      controller.setError('name', 'Name is required');
      expect(controller.errors['name'], 'Name is required');

      controller.clearErrors();
      expect(controller.errors['name'], isNull);

      controller.dispose();
    });
  });

  group('FieldDependency', () {
    test('isVisible returns true when condition is met', () {
      final dependency = FieldDependency(
        dependsOn: 'rating',
        condition: (val) => (val ?? 0) < 3,
      );
      expect(dependency.isVisible({'rating': 2}), isTrue);
      expect(dependency.isVisible({'rating': 4}), isFalse);
    });

    test('isVisible handles missing parent value', () {
      final dependency = FieldDependency(
        dependsOn: 'country',
        condition: (val) => val != null,
      );
      expect(dependency.isVisible({}), isFalse);
    });
  });

  group('DropdownItem', () {
    test('equality works correctly', () {
      final item1 = DropdownItem(id: 'a', label: 'A');
      final item2 = DropdownItem(id: 'a', label: 'A');
      final item3 = DropdownItem(id: 'b', label: 'B');

      expect(item1 == item2, isTrue);
      expect(item1 == item3, isFalse);
    });

    test('sublabel is optional', () {
      final item = DropdownItem(id: 'a', label: 'A', sublabel: 'Sublabel');
      expect(item.sublabel, 'Sublabel');

      final itemNoSublabel = DropdownItem(id: 'b', label: 'B');
      expect(itemNoSublabel.sublabel, isNull);
    });
  });
}
