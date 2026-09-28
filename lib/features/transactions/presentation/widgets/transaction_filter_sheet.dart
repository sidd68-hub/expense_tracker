import 'package:flutter/material.dart';

import '../../../accounts/domain/entities/account_entity.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/entities/transaction_filter.dart';
import '../../domain/entities/transaction_type.dart';

Future<TransactionFilter?> showTransactionFilterSheet(
  BuildContext context, {
  required TransactionFilter current,
  required List<CategoryEntity> categories,
  required List<AccountEntity> accounts,
}) {
  return showModalBottomSheet<TransactionFilter>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _FilterSheet(current: current, categories: categories, accounts: accounts),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.current, required this.categories, required this.accounts});

  final TransactionFilter current;
  final List<CategoryEntity> categories;
  final List<AccountEntity> accounts;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late Set<TransactionType> _types;
  String? _categoryId;
  String? _accountId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _types = widget.current.types?.toSet() ?? {};
    _categoryId = widget.current.categoryId;
    _accountId = widget.current.accountId;
    _startDate = widget.current.startDate;
    _endDate = widget.current.endDate;
  }

  void _applyPreset(DateTimeRange range) {
    setState(() {
      _startDate = range.start;
      _endDate = range.end;
    });
  }

  DateTimeRange _thisMonth() {
    final now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
  }

  DateTimeRange _lastMonth() {
    final now = DateTime.now();
    final firstOfThisMonth = DateTime(now.year, now.month, 1);
    final lastMonthEnd = firstOfThisMonth.subtract(const Duration(days: 1));
    return DateTimeRange(start: DateTime(lastMonthEnd.year, lastMonthEnd.month, 1), end: lastMonthEnd);
  }

  DateTimeRange _thisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    return DateTimeRange(start: DateTime(start.year, start.month, start.day), end: now);
  }

  DateTimeRange _thisYear() {
    final now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, 1, 1), end: now);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter transactions', style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () => Navigator.pop(context, const TransactionFilter()),
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Type', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TransactionType.values.map((type) {
                  final selected = _types.contains(type);
                  return FilterChip(
                    label: Text(type.name),
                    selected: selected,
                    onSelected: (value) => setState(() {
                      if (value) {
                        _types.add(type);
                      } else {
                        _types.remove(type);
                      }
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Date range', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(label: const Text('This week'), onPressed: () => _applyPreset(_thisWeek())),
                  ActionChip(label: const Text('This month'), onPressed: () => _applyPreset(_thisMonth())),
                  ActionChip(label: const Text('Last month'), onPressed: () => _applyPreset(_lastMonth())),
                  ActionChip(label: const Text('This year'), onPressed: () => _applyPreset(_thisYear())),
                  ActionChip(
                    label: const Text('Custom'),
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDateRange: _startDate != null && _endDate != null
                            ? DateTimeRange(start: _startDate!, end: _endDate!)
                            : null,
                      );
                      if (range != null) _applyPreset(range);
                    },
                  ),
                  if (_startDate != null)
                    InputChip(
                      label: const Text('Clear dates'),
                      onPressed: () => setState(() {
                        _startDate = null;
                        _endDate = null;
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Category', style: Theme.of(context).textTheme.labelLarge),
              DropdownButtonFormField<String?>(
                initialValue: _categoryId,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any category')),
                  ...widget.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                ],
                onChanged: (value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 8),
              Text('Account', style: Theme.of(context).textTheme.labelLarge),
              DropdownButtonFormField<String?>(
                initialValue: _accountId,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any account')),
                  ...widget.accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))),
                ],
                onChanged: (value) => setState(() => _accountId = value),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    TransactionFilter(
                      types: _types.isEmpty ? null : _types.toList(),
                      categoryId: _categoryId,
                      accountId: _accountId,
                      startDate: _startDate,
                      endDate: _endDate,
                      searchText: widget.current.searchText,
                    ),
                  );
                },
                child: const Text('Apply filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
