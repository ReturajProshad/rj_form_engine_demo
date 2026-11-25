import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

class RepeatableGroupDemo extends StatefulWidget {
  const RepeatableGroupDemo({super.key});

  @override
  State<RepeatableGroupDemo> createState() => _RepeatableGroupDemoState();
}

class _RepeatableGroupDemoState extends State<RepeatableGroupDemo> {
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
    FieldMeta.group(
      key: 'items',
      label: 'Line Items',
      fields: [
        FieldMeta.text(
          key: 'name',
          label: 'Item',
          required: true,
          hint: 'e.g. Apples',
          layout: const RjLayout(md: RjSpan.quarter),
        ),
        FieldMeta.number(
          key: 'qty',
          label: 'Qty',
          layout: const RjLayout(md: RjSpan.quarter),
        ),
        FieldMeta.number(
          key: 'rate',
          label: 'Rate',
          layout: const RjLayout(md: RjSpan.quarter),
        ),
        FieldMeta.number(
          key: 'lineTotal',
          label: 'Line Total',
          derivation: FieldDerivation(
            derivesFrom: ['qty', 'rate'],
            compute: (state) {
              final qty = (state['qty'] as num?)?.toDouble() ?? 0;
              final rate = (state['rate'] as num?)?.toDouble() ?? 0;
              return qty * rate;
            },
          ),
          layout: const RjLayout(md: RjSpan.quarter),
        ),
      ],
      config: const GroupConfig(
        addButtonLabel: 'Add Line Item',
        removeButtonLabel: 'Remove',
        minRows: 1,
      ),
    ),
    FieldMeta.number(
      key: 'grandTotal',
      label: 'Grand Total',
      derivation: FieldDerivation(
        derivesFrom: ['items'],
        compute: (state) {
          final rows = state['items'] as List? ?? const [];
          var sum = 0.0;
          for (final r in rows) {
            if (r is Map) {
              sum += (r['lineTotal'] as num?)?.toDouble() ?? 0;
            }
          }
          return sum;
        },
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repeatable Group Demo'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: RjForm(
          controller: controller,
          fields: fields,
          onSubmit: null,
          hideSubmitButton: true,
          showErrorsSummary: true,
        ),
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
        final secondary = Theme.of(ctx).brightness == Brightness.dark
            ? AppTheme.darkTextSecondary
            : AppTheme.lightTextSecondary;

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
                children: [
                  Text(
                    'Line Items',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final (i, row)
                      in ((values['items'] as List?) ?? const []).indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text(
                            '${i + 1}. ',
                            style: TextStyle(fontSize: 14, color: secondary),
                          ),
                          Text(
                            '${row['name'] ?? ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _money(
                              ((row['lineTotal'] as num?)?.toDouble() ?? 0),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Grand Total',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        _money(
                          ((values['grandTotal'] as num?)?.toDouble() ?? 0),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
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

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
}
