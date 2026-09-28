import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/utils/validators.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/domain/entities/category_type.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../domain/entities/budget_entity.dart';
import '../controllers/budget_providers.dart';

Future<void> showBudgetEditSheet(BuildContext context, {BudgetEntity? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => _BudgetEditSheet(existing: existing),
  );
}

class _BudgetEditSheet extends ConsumerStatefulWidget {
  const _BudgetEditSheet({this.existing});

  final BudgetEntity? existing;

  @override
  ConsumerState<_BudgetEditSheet> createState() => _BudgetEditSheetState();
}

class _BudgetEditSheetState extends ConsumerState<_BudgetEditSheet> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  late BudgetScope _scope;
  String? _categoryId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _scope = widget.existing?.scope ?? BudgetScope.category;
    _categoryId = widget.existing?.categoryId;
    if (widget.existing != null) {
      _limitController.text = (widget.existing!.limitMinor / 100).toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_scope == BudgetScope.category && _categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a category')));
      return;
    }

    setState(() => _saving = true);
    final limitMinor = (double.parse(_limitController.text.trim()) * 100).round();
    final repository = ref.read(budgetRepositoryProvider);
    try {
      final budget = BudgetEntity(
        id: widget.existing?.id ?? '',
        scope: _scope,
        categoryId: _scope == BudgetScope.category ? _categoryId : null,
        monthKey: currentMonthKey(),
        limitMinor: limitMinor,
      );
      if (widget.existing != null) {
        await repository.update(budget);
      } else {
        await repository.create(budget);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseCategories = ref.watch(expenseCategoriesProvider).value ?? const <CategoryEntity>[];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existing != null ? 'Edit budget' : 'New budget',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SegmentedButton<BudgetScope>(
                segments: const [
                  ButtonSegment(value: BudgetScope.overall, label: Text('Overall')),
                  ButtonSegment(value: BudgetScope.category, label: Text('Category')),
                ],
                selected: {_scope},
                onSelectionChanged: (selection) => setState(() => _scope = selection.first),
              ),
              if (_scope == BudgetScope.category) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: expenseCategories
                      .where((c) => c.type == CategoryType.expense)
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _limitController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Monthly limit', prefixText: '₹ '),
                validator: Validators.amount,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
