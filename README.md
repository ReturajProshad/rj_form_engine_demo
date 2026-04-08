# RjFormEngine Demo

A practical Flutter demo app that showcases how to integrate and use
RjFormEngine in real forms. This project demonstrates default and custom
fields, theming, validation, cascading dropdowns, date/time fields, and
more — all wired via schema-driven FieldMeta definitions.

Key package used: `rj_form_engine` (local path in pubspec.yaml).
---


## 📸 Preview

### Video Demo
See the engine in action, including dynamic validation, cascading logic, and smooth field transitions:

https://github.com/user-attachments/assets/420abb19-a3e8-4ae9-b4c7-3b6e0881237c

### Screenshots

| Default Fields | Automatic Error Handling | Dark/Custom Theme |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/3cebb8a9-8e70-49f0-a8bb-c4df34855e14" width="250"> | <img src="https://github.com/user-attachments/assets/189e073e-af23-48a3-a379-57e9a80d1ccd" width="250"> | <img src="https://github.com/user-attachments/assets/d31624e9-01c0-4ec3-8ac0-49d0a229f68d" width="250"> |

| Custom Fields Support | Form Entry Page |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/b0f4f59e-860b-4a81-9180-bdc941f2f5f4" width="250"> | <img src="https://github.com/user-attachments/assets/9fc8ac3b-8acc-4029-a5f7-07fd6d42ed84" width="250"> |

---
## Project Overview

This demo contains a home screen that navigates to several sample forms:

- Default Fields & Style: standard built-in field types with sensible defaults
- Custom Fields: star rating, color picker, tags, and more via FieldMeta.custom
- Mixed Themed Demo: a production-ready form with custom theming
- Login Page: a small authentication-style form

Each demo is implemented with RjForm and a variety of FieldMeta definitions to
showcase the engine's capabilities.

Main entry point is lib/main.dart. The app uses a theme toggle and a home
screen that links to the demos.

## Running the Demo

- From the repo root: `flutter pub get` then `flutter run`.
- The app will launch on your connected device or emulator. You can switch
  between light and dark themes using the in-app toggle.

If you want to explore or customize the demo:

- Inspect the demo screens under `lib/screens/` (default_fields_demo.dart,
  custom_fields_demo.dart, mixed_themed_demo.dart, login_page.dart).
- Modify or extend `FieldMeta` definitions to see how the engine renders new
  fields, applies validators, and handles dependencies.
- Update `lib/theme/app_theme.dart` to customize global styling.

## Key Concepts (Quick Reference)

- RjForm: the widget that renders a form from a list of FieldMeta definitions.
- FieldMeta: the blueprint for a single form field (key, label, type, validators, etc.).
- FormController: optional external controller for programmatic access to form state.
- Validators: built-in and custom validators that run after the required check.
- Dependencies: support for conditional visibility and cascading dropdowns.

Files of interest:

- lib/main.dart
- lib/screens/home_screen.dart
- lib/screens/default_fields_demo.dart
- lib/screens/custom_fields_demo.dart
- lib/screens/mixed_themed_demo.dart
- lib/screens/login_page.dart
- lib/theme/app_theme.dart

## Features Demonstrated

- Schema-driven forms with 13+ field types (text, number, date, dropdown, etc.)
- Custom fields via FieldMeta.custom
- Cascading and dynamic dropdowns
- Theming and light/dark mode
- Validation and error summaries
- External FormController usage
- Real-time onChanged callbacks
- Image uploads via the engine (demo integration)

## Contributing

Contributions are welcome. If you find issues or have feature requests, please
open an issue or submit a pull request with a clear description and reproduction
steps.

This demo is primarily a consumer of the RjFormEngine package to illustrate
practical usage and patterns.

## License

MIT — see LICENSE
