import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/utils/money.dart';
import '../../../../core/common/utils/validators.dart';
import '../../../../core/common/widgets/state_views.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../accounts/presentation/widgets/account_picker_sheet.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../../categories/presentation/widgets/category_picker_sheet.dart';
import '../../domain/entities/category_suggester.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/entities/transaction_validator.dart';
import '../controllers/transaction_form_controller.dart';
import '../widgets/transaction_type_selector.dart';

/// Add/Edit Transaction screen. Pass [transactionId] to edit an existing
/// transaction, or leave it null (with an optional [initialType]) to add one.
class AddEditTransactionScreen extends ConsumerStatefulWidget {
  const AddEditTransactionScreen({super.key, this.transactionId, this.initialType});

  final String? transactionId;
  final TransactionType? initialType;

  bool get isEdit => transactionId != null;

  @override
  ConsumerState<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _remarkController = TextEditingController();

  late TransactionType _type;
  DateTime _date = DateTime.now();
  String? _categoryId;
  String? _accountId;
  String? _fromAccountId;
  String? _toAccountId;
  bool _categoryManuallyChosen = false;
  bool _prefilled = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? TransactionType.expense;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _prefillFrom(TransactionEntity transaction) {
    _type = transaction.type;
    _date = transaction.date;
    _amountController.text = transaction.amount.majorUnits.toString();
    _merchantController.text = transaction.merchant ?? '';
    _remarkController.text = transaction.remark ?? '';
    _categoryId = transaction.categoryId;
    _accountId = transaction.accountId;
    _fromAccountId = transaction.fromAccountId;
    _toAccountId = transaction.toAccountId;
    _categoryManuallyChosen = true;
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_date));
    if (!mounted) return;
    setState(() {
      _date = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime?.hour ?? _date.hour,
        pickedTime?.minute ?? _date.minute,
      );
    });
  }

  void _onMerchantChanged(String value, List<CategoryEntity> expenseCategories) {
    if (_categoryManuallyChosen || _type != TransactionType.expense) return;
    final suggestedName = CategorySuggester.suggestCategoryName(value);
    if (suggestedName == null) return;
    final match = _findByName(expenseCategories, suggestedName);
    if (match != null && match.id != _categoryId) {
      setState(() => _categoryId = match.id);
    }
  }

  CategoryEntity? _findByName(List<CategoryEntity> categories, String name) {
    for (final category in categories) {
      if (category.name.toLowerCase() == name.toLowerCase()) return category;
    }
    return null;
  }

  CategoryEntity? _findById(List<CategoryEntity> categories, String? id) {
    if (id == null) return null;
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  AccountEntity? _findAccountById(List<AccountEntity> accounts, String? id) {
    if (id == null) return null;
    for (final account in accounts) {
      if (account.id == id) return account;
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amountMajor = double.parse(_amountController.text.trim());
    final transaction = TransactionEntity(
      id: widget.transactionId ?? '',
      type: _type,
      amount: MoneyAmount.fromMajorUnits(amountMajor),
      date: _date,
      categoryId: _type == TransactionType.transfer ? null : _categoryId,
      accountId: _type == TransactionType.transfer ? null : _accountId,
      fromAccountId: _type == TransactionType.transfer ? _fromAccountId : null,
      toAccountId: _type == TransactionType.transfer ? _toAccountId : null,
      merchant: _merchantController.text.trim().isEmpty ? null : _merchantController.text.trim(),
      remark: _remarkController.text.trim().isEmpty ? null : _remarkController.text.trim(),
    );

    final error = TransactionValidator.validate(transaction);
    if (error != null) {
      setState(() => _validationError = error);
      return;
    }
    setState(() => _validationError = null);

    await ref.read(transactionFormControllerProvider.notifier).save(transaction, isEdit: widget.isEdit);

    final state = ref.read(transactionFormControllerProvider);
    if (!mounted) return;
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      final transactionAsync = ref.watch(transactionByIdProvider(widget.transactionId!));
      return transactionAsync.when(
        loading: () => Scaffold(appBar: AppBar(title: const Text('Edit Transaction')), body: const LoadingView()),
        error: (error, _) =>
            Scaffold(appBar: AppBar(title: const Text('Edit Transaction')), body: ErrorView(message: error.toString())),
        data: (transaction) {
          if (transaction == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit Transaction')),
              body: const ErrorView(message: 'Transaction not found'),
            );
          }
          if (!_prefilled) {
            _prefillFrom(transaction);
            _prefilled = true;
          }
          return _buildForm(context);
        },
      );
    }
    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context) {
    final expenseCategories = ref.watch(expenseCategoriesProvider).value ?? const [];
    final incomeCategories = ref.watch(incomeCategoriesProvider).value ?? const [];
    final categoriesForType = _type == TransactionType.income ? incomeCategories : expenseCategories;
    final accounts = ref.watch(activeAccountsProvider).value ?? const [];

    final selectedCategory = _findById(categoriesForType, _categoryId);
    final selectedAccount = _findAccountById(accounts, _accountId);
    final fromAccount = _findAccountById(accounts, _fromAccountId);
    final toAccount = _findAccountById(accounts, _toAccountId);

    final isSaving = ref.watch(transactionFormControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit Transaction' : 'Add Transaction')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TransactionTypeSelector(
                  value: _type,
                  onChanged: (type) => setState(() {
                    _type = type;
                    _categoryId = null;
                    _accountId = null;
                    _categoryManuallyChosen = false;
                  }),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹ '),
                  validator: Validators.amount,
                ),
                const SizedBox(height: 16),
                if (_type == TransactionType.transfer) ...[
                  _PickerField(
                    label: 'From account',
                    valueText: fromAccount?.name,
                    onTap: () async {
                      final picked = await showAccountPickerSheet(
                        context,
                        accounts: accounts,
                        excludeAccountId: _toAccountId,
                      );
                      if (picked != null) setState(() => _fromAccountId = picked.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  _PickerField(
                    label: 'To account',
                    valueText: toAccount?.name,
                    onTap: () async {
                      final picked = await showAccountPickerSheet(
                        context,
                        accounts: accounts,
                        excludeAccountId: _fromAccountId,
                      );
                      if (picked != null) setState(() => _toAccountId = picked.id);
                    },
                  ),
                ] else ...[
                  TextFormField(
                    controller: _merchantController,
                    decoration: const InputDecoration(labelText: 'Merchant / Payee (optional)'),
                    onChanged: (value) => _onMerchantChanged(value, expenseCategories),
                  ),
                  const SizedBox(height: 12),
                  _PickerField(
                    label: 'Category',
                    valueText: selectedCategory?.name,
                    onTap: () async {
                      final picked = await showCategoryPickerSheet(context, categories: categoriesForType);
                      if (picked != null) {
                        setState(() {
                          _categoryId = picked.id;
                          _categoryManuallyChosen = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _PickerField(
                    label: 'Account / Payment method',
                    valueText: selectedAccount?.name,
                    onTap: () async {
                      final picked = await showAccountPickerSheet(context, accounts: accounts);
                      if (picked != null) setState(() => _accountId = picked.id);
                    },
                  ),
                ],
                const SizedBox(height: 12),
                _PickerField(
                  label: 'Date & time',
                  valueText: DateFormat('d MMM yyyy, h:mm a').format(_date),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _remarkController,
                  decoration: const InputDecoration(labelText: 'Remark (optional)'),
                  maxLines: 2,
                ),
                if (_validationError != null) ...[
                  const SizedBox(height: 12),
                  Text(_validationError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isSaving ? null : _submit,
                  child: isSaving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(widget.isEdit ? 'Save changes' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({required this.label, required this.valueText, required this.onTap});

  final String label;
  final String? valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              valueText ?? 'Select',
              style: TextStyle(
                color: valueText == null ? Theme.of(context).colorScheme.outline : null,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
