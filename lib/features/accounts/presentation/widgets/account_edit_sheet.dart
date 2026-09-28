import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_type.dart';
import '../controllers/account_providers.dart';
import 'account_type_icon.dart';

Future<void> showAccountEditSheet(BuildContext context, {AccountEntity? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => _AccountEditSheet(existing: existing),
  );
}

class _AccountEditSheet extends ConsumerStatefulWidget {
  const _AccountEditSheet({this.existing});

  final AccountEntity? existing;

  @override
  ConsumerState<_AccountEditSheet> createState() => _AccountEditSheetState();
}

class _AccountEditSheetState extends ConsumerState<_AccountEditSheet> {
  late final TextEditingController _nameController;
  late AccountType _type;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _type = widget.existing?.type ?? AccountType.bank;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final repository = ref.read(accountRepositoryProvider);
    try {
      if (widget.existing != null) {
        await repository.update(widget.existing!.copyWith(name: name, type: _type));
      } else {
        await repository.create(AccountEntity(id: '', name: name, type: _type));
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing != null ? 'Edit account' : 'New account',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name (e.g. HDFC Bank, PhonePe)'),
              autofocus: widget.existing == null,
            ),
            const SizedBox(height: 16),
            Text('Type', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AccountType.values.map((type) {
                final selected = type == _type;
                return ChoiceChip(
                  avatar: AccountTypeIcon(type: type),
                  label: Text(type.name),
                  selected: selected,
                  onSelected: (_) => setState(() => _type = type),
                );
              }).toList(),
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
    );
  }
}
