import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool _obscurePassword = true;

  void _handleLogin(FormResult result) {
    debugPrint('Login Data: ${result.values}');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 48),
            Text("Demo First"),
            RjForm(
              onSuccess: _handleLogin,
              theme: RjFormTheme(
                primaryColor: AppTheme.primaryColor,
                borderColor: isDark
                    ? AppTheme.darkBorder
                    : AppTheme.lightBorder,
                errorColor: AppTheme.errorColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                fieldSpacing: 10,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                fieldFillColor: isDark
                    ? AppTheme.darkFieldFill
                    : AppTheme.lightFieldFill,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
                ),
                submitButtonColor: AppTheme.primaryColor,
                // submitButtonText: 'Sign In',
              ),
              fields: [
                // Email + Password — side by side on tablet+
                FieldMeta.text(
                  key: "email",
                  label: "Email Address",
                  required: true,
                  hint: "Enter your email",
                  validators: [RjValidators.required(), RjValidators.email()],
                  layout: const RjLayout(md: RjSpan.third),
                ),
                FieldMeta.text(
                  key: "password",
                  label: "Password",
                  required: true,
                  obscureText: _obscurePassword,
                  hint: "Enter your password",
                  validators: [
                    RjValidators.required(),
                    RjValidators.minLength(6),
                  ],
                  toggleObscure: true,
                  layout: const RjLayout(md: RjSpan.third),
                ),
                FieldMeta.custom(
                  key: "submitLogin",
                  label: "label",
                  showLabel: false,
                  layout: RjLayout(lg: RjSpan.third),
                  builder: (context, field, value, onChanged, errorText) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.all(20),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.indigo,
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Submit Button",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              // onSubmit: (result) async {},
            ),
            const SizedBox(height: 48),
            Text("Demo Second"),
            RjForm(
              onSuccess: _handleLogin,
              theme: RjFormTheme(
                primaryColor: AppTheme.primaryColor,
                borderColor: isDark
                    ? AppTheme.darkBorder
                    : AppTheme.lightBorder,
                errorColor: AppTheme.errorColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                fieldSpacing: 10,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                fieldFillColor: isDark
                    ? AppTheme.darkFieldFill
                    : AppTheme.lightFieldFill,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
                ),
                submitButtonColor: AppTheme.primaryColor,
                // submitButtonText: 'Sign In',
              ),
              fields: [
                // Email + Password — side by side on tablet+
                FieldMeta.text(
                  key: "email",
                  label: "Email Address",
                  required: true,
                  hint: "Enter your email",
                  validators: [RjValidators.required(), RjValidators.email()],
                  layout: const RjLayout(md: RjSpan.third),
                ),
                FieldMeta.text(
                  key: "password",
                  label: "Password",
                  required: true,
                  obscureText: _obscurePassword,
                  hint: "Enter your password",
                  validators: [
                    RjValidators.required(),
                    RjValidators.minLength(6),
                  ],
                  toggleObscure: true,
                  layout: const RjLayout(md: RjSpan.third),
                ),
                FieldMeta.custom(
                  key: "submitLogin",
                  label: "label",
                  showLabel: false,
                  layout: RjLayout(lg: RjSpan.half),
                  builder: (context, field, value, onChanged, errorText) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.all(20),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.indigo,
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Submit Button",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              // onSubmit: (result) async {},
            ),
          ],
        ),
      ),
    );
  }
}
