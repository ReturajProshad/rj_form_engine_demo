import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

class DerivationDemo extends StatefulWidget {
  const DerivationDemo({super.key});

  @override
  State<DerivationDemo> createState() => _DerivationDemoState();
}

class _DerivationDemoState extends State<DerivationDemo> {
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

  List<FieldMeta> get fields => [
        FieldMeta.section(key: 'sec_simple', label: 'Simple Derivation'),
        // Input + derived output — side by side
        FieldMeta.number(
          key: 'default_value',
          label: 'Default Value',
          required: true,
          hint: 'Enter a number',
          layout: const RjLayout(md: RjSpan.half),
        ),
        FieldMeta.number(
          key: 'derived_from_default',
          label: 'Doubled (auto)',
          derivation: FieldDerivation(
            derivesFrom: ['default_value'],
            compute: (state) {
              final val = (state['default_value'] as num?)?.toDouble();
              return val != null ? val * 2 : null;
            },
          ),
          layout: const RjLayout(md: RjSpan.half),
        ),
        FieldMeta.section(
          key: 'sec_multi',
          label: 'Multi-Source Derivation',
        ),
        // Price + Quantity — side by side
        FieldMeta.number(
          key: 'price',
          label: 'Price',
          required: true,
          hint: 'Enter price',
          layout: const RjLayout(md: RjSpan.half),
        ),
        FieldMeta.number(
          key: 'quantity',
          label: 'Quantity',
          required: true,
          hint: 'Enter quantity',
          layout: const RjLayout(md: RjSpan.half),
        ),
        // Total — full width (derived field)
        FieldMeta.number(
          key: 'total',
          label: 'Total (auto)',
          derivation: FieldDerivation(
            derivesFrom: ['price', 'quantity'],
            compute: (state) {
              final price = (state['price'] as num?)?.toDouble() ?? 0;
              final qty = (state['quantity'] as num?)?.toDouble() ?? 0;
              return price * qty;
            },
          ),
        ),
        FieldMeta.section(
          key: 'sec_label_shadow',
          label: 'Label Shadowing (Dropdown)',
        ),
        // Category + Item — side by side
        FieldMeta.dropdown(
          key: 'category',
          label: 'Category',
          required: true,
          dropdownSource: DropdownSource.static([
            DropdownItem(id: 'fruit', label: 'Fruit'),
            DropdownItem(id: 'dairy', label: 'Dairy'),
            DropdownItem(id: 'meat', label: 'Meat'),
          ]),
          layout: const RjLayout(md: RjSpan.half),
        ),
        FieldMeta.dropdown(
          key: 'item',
          label: 'Item',
          required: true,
          dependency: FieldDependency(
            dependsOn: 'category',
            condition: (val) => val != null,
          ),
          dropdownSource: DropdownSource.async(({parentValue}) async {
            await Future.delayed(const Duration(milliseconds: 300));
            switch (parentValue) {
              case 'fruit':
                return [
                  DropdownItem(id: 'apple', label: 'Apple'),
                  DropdownItem(id: 'banana', label: 'Banana'),
                  DropdownItem(id: 'orange', label: 'Orange'),
                ];
              case 'dairy':
                return [
                  DropdownItem(id: 'milk', label: 'Milk'),
                  DropdownItem(id: 'cheese', label: 'Cheese'),
                  DropdownItem(id: 'yogurt', label: 'Yogurt'),
                ];
              case 'meat':
                return [
                  DropdownItem(id: 'chicken', label: 'Chicken'),
                  DropdownItem(id: 'beef', label: 'Beef'),
                  DropdownItem(id: 'fish', label: 'Fish'),
                ];
              default:
                return [];
            }
          }),
          layout: const RjLayout(md: RjSpan.half),
        ),
        // Auto Tag — full width (derived output)
        FieldMeta.text(
          key: 'derived_tag',
          label: 'Auto Tag (auto)',
          derivation: FieldDerivation(
            derivesFrom: ['category', 'item'],
            compute: (state) {
              final catLabel = state['categoryLabel'] ?? '';
              final itemLabel = state['itemLabel'] ?? '';
              if (catLabel.isEmpty && itemLabel.isEmpty) return null;
              final parts = [catLabel, itemLabel]
                  .where((p) => p != null && p.isNotEmpty);
              return parts.join(' - ');
            },
          ),
        ),
        FieldMeta.section(
          key: 'sec_label_custom',
          label: 'Label Customization',
        ),
        // Hidden label + Styled label — side by side
        FieldMeta.text(
          key: 'hidden_label_field',
          label: 'This label is hidden',
          hint: 'No label shown above — only this hint',
          showLabel: false,
          layout: const RjLayout(md: RjSpan.half),
        ),
        FieldMeta.text(
          key: 'styled_label_field',
          label: 'Default label (not shown)',
          hint: 'Custom label above with styling',
          showLabel: true,
          labelConfig: const RjLabelText(
            text: 'Styled Custom Label',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
              letterSpacing: 1.2,
            ),
          ),
          layout: const RjLayout(md: RjSpan.half),
        ),
        // Custom widget label — full width
        FieldMeta.number(
          key: 'custom_widget_label',
          label: 'Default label (not shown)',
          hint: 'Enter a value',
          showLabel: true,
          labelConfig: RjLabelCustom((context) {
            final theme = Theme.of(context);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded,
                      color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Custom Widget Label',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Derivation Demo'),
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
                onSubmit: null,
                hideSubmitButton: true,
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
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatValue(val),
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

  String _formatValue(dynamic val) {
    if (val is DateTime) return RjTimeUtils.formatDate(val);
    if (val is TimeOfDay) return RjTimeUtils.format(val);
    if (val is List) return val.join(', ');
    if (val is bool) return val ? 'Yes' : 'No';
    if (val == null) return '';
    return val.toString();
  }
}
