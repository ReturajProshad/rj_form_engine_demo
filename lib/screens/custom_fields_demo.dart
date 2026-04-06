import 'package:flutter/material.dart';
import 'package:rj_form_engine/rj_form_engine.dart';
import 'package:rj_form_engine_tests_project/main.dart';
import 'package:rj_form_engine_tests_project/theme/app_theme.dart';

class CustomFieldsDemo extends StatefulWidget {
  const CustomFieldsDemo({super.key});

  @override
  State<CustomFieldsDemo> createState() => _CustomFieldsDemoState();
}

class _CustomFieldsDemoState extends State<CustomFieldsDemo> {
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
    FieldMeta.section(key: 'sec_rating', label: 'Rating & Feedback'),
    FieldMeta.custom(
      key: 'rating',
      label: 'Overall Rating',
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
            const SizedBox(height: 12),
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
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  rating <= 2
                      ? 'Needs Improvement'
                      : rating == 3
                      ? 'Average'
                      : rating == 4
                      ? 'Good'
                      : 'Excellent!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: rating <= 2
                        ? AppTheme.errorColor
                        : AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  errorText,
                  style: TextStyle(color: AppTheme.errorColor, fontSize: 12),
                ),
              ),
          ],
        );
      },
    ),
    FieldMeta.custom(
      key: 'feedback',
      label: 'Detailed Feedback',
      dependency: FieldDependency(
        dependsOn: 'rating',
        condition: (val) => (val ?? 0) < 4,
      ),
      builder: (context, field, value, onChanged, errorText) {
        return TextField(
          decoration: InputDecoration(
            labelText: 'Tell us more about your experience',
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
          ),
          maxLines: 4,
          onChanged: onChanged,
        );
      },
    ),
    FieldMeta.section(key: 'sec_appearance', label: 'Appearance'),
    FieldMeta.custom(
      key: 'color_preference',
      label: 'Brand Color',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final selectedColor = value as Color?;

        final colors = [
          Colors.red,
          Colors.orange,
          Colors.amber,
          Colors.green,
          Colors.teal,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
          Colors.pink,
          Colors.brown,
          Colors.cyan,
          Colors.lime,
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
              spacing: 14,
              runSpacing: 14,
              children: colors.map((color) {
                final isSelected = selectedColor == color;
                return GestureDetector(
                  onTap: () => onChanged(isSelected ? null : color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? (isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.lightTextPrimary)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            size: 24,
                          )
                        : null,
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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final tags = value is List<String> ? value : <String>[];

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
                  width: 140,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add tag + Enter',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusSm,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      isDense: true,
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        final newTags = List<String>.from(tags)
                          ..add(val.trim());
                        onChanged(newTags);
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
      key: 'priority',
      label: 'Priority Level',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final selected = value as String?;

        final priorities = [
          {
            'id': 'low',
            'label': 'Low',
            'icon': Icons.arrow_downward_rounded,
            'color': AppTheme.successColor,
          },
          {
            'id': 'medium',
            'label': 'Medium',
            'icon': Icons.remove_rounded,
            'color': AppTheme.accentColor,
          },
          {
            'id': 'high',
            'label': 'High',
            'icon': Icons.arrow_upward_rounded,
            'color': Colors.orange,
          },
          {
            'id': 'urgent',
            'label': 'Urgent',
            'icon': Icons.error_rounded,
            'color': AppTheme.errorColor,
          },
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
              spacing: 10,
              runSpacing: 10,
              children: priorities.map((p) {
                final isSelected = selected == p['id'];
                final color = p['color'] as Color;
                return GestureDetector(
                  onTap: () => onChanged(isSelected ? null : p['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.12)
                          : (isDark
                                ? AppTheme.darkSurfaceVariant
                                : AppTheme.lightSurfaceVariant),
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusSm,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? color
                            : (isDark
                                  ? AppTheme.darkBorder
                                  : AppTheme.lightBorder),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          p['icon'] as IconData,
                          size: 18,
                          color: isSelected
                              ? color
                              : (isDark
                                    ? AppTheme.darkTextHint
                                    : AppTheme.lightTextHint),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          p['label'] as String,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? color
                                : (isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    ),
    FieldMeta.section(key: 'sec_custom_select', label: 'Custom Selection'),
    FieldMeta.custom(
      key: 'team',
      label: 'Team Assignment',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final selected = value as String?;

        final teams = [
          {
            'id': 'design',
            'label': 'Design',
            'avatar': '🎨',
            'color': Colors.purple,
          },
          {
            'id': 'dev',
            'label': 'Development',
            'avatar': '💻',
            'color': Colors.blue,
          },
          {'id': 'qa', 'label': 'QA', 'avatar': '🔍', 'color': Colors.green},
          {
            'id': 'pm',
            'label': 'Product',
            'avatar': '📋',
            'color': Colors.orange,
          },
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
            ...teams.map((team) {
              final isSelected = selected == team['id'];
              final color = team['color'] as Color;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onChanged(isSelected ? null : team['id']),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.08)
                            : (isDark
                                  ? AppTheme.darkFieldFill
                                  : AppTheme.lightFieldFill),
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : (isDark
                                    ? AppTheme.darkBorder
                                    : AppTheme.lightBorder),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                team['avatar'] as String,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              team['label'] as String,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isDark
                                    ? AppTheme.darkTextPrimary
                                    : AppTheme.lightTextPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isSelected
                                ? color
                                : (isDark
                                      ? AppTheme.darkTextHint
                                      : AppTheme.lightTextHint),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    ),
    FieldMeta.custom(
      key: 'date_range',
      label: 'Date Range',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final range = value is Map<String, DateTime> ? value : null;

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
            Row(
              children: [
                Expanded(
                  child: _DateButton(
                    label: 'Start Date',
                    date: range?['start'],
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: range?['start'] ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        onChanged({...?range, 'start': picked});
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: isDark
                      ? AppTheme.darkTextHint
                      : AppTheme.lightTextHint,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateButton(
                    label: 'End Date',
                    date: range?['end'],
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            range?['end'] ??
                            DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        onChanged({...?range, 'end': picked});
                      }
                    },
                  ),
                ),
              ],
            ),
            if (range != null && range['start'] != null && range['end'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        (isDark ? AppTheme.primaryLight : AppTheme.primaryColor)
                            .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusSm,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: isDark
                            ? AppTheme.primaryLight
                            : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${range['end']!.difference(range['start']!).inDays} days',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTheme.primaryLight
                              : AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    ),
    FieldMeta.custom(
      key: 'app_info',
      label: 'App Info',
      builder: (context, field, value, onChanged, errorText) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppTheme.darkSurfaceVariant
                : AppTheme.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Custom Fields Demo • All widgets built with builder pattern',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ];

  Future<void> _handleSubmit(FormResult result) async {
    debugPrint('CUSTOM FORM RESULT: ${result.values}');
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
    if (val is Map) {
      final parts = <String>[];
      if (val['start'] is DateTime) {
        parts.add('Start: ${RjTimeUtils.formatDate(val['start'])}');
      }
      if (val['end'] is DateTime) {
        parts.add('End: ${RjTimeUtils.formatDate(val['end'])}');
      }
      return parts.join('\n');
    }
    if (val is Color) {
      return '#${val.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
    }
    if (val is List) return val.join(', ');
    if (val is bool) return val ? 'Yes' : 'No';
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Fields'),
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

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkFieldFill : AppTheme.lightFieldFill,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppTheme.darkTextHint
                      : AppTheme.lightTextHint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date != null ? RjTimeUtils.formatDate(date!) : 'Select',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: date != null
                      ? (isDark ? AppTheme.primaryLight : AppTheme.primaryColor)
                      : (isDark
                            ? AppTheme.darkTextHint
                            : AppTheme.lightTextHint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
