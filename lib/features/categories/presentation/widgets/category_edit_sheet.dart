import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/constants/category_icons.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/category_type.dart';
import '../controllers/category_providers.dart';

Future<void> showCategoryEditSheet(
  BuildContext context, {
  required CategoryType type,
  CategoryEntity? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => _CategoryEditSheet(type: type, existing: existing),
  );
}

class _CategoryEditSheet extends ConsumerStatefulWidget {
  const _CategoryEditSheet({required this.type, this.existing});

  final CategoryType type;
  final CategoryEntity? existing;

  @override
  ConsumerState<_CategoryEditSheet> createState() => _CategoryEditSheetState();
}

class _CategoryEditSheetState extends ConsumerState<_CategoryEditSheet> {
  late final TextEditingController _nameController;
  late String _iconKey;
  late int _color;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _iconKey = widget.existing?.iconKey ?? CategoryIcons.map.keys.first;
    _color = widget.existing?.color ?? CategoryColors.palette.first.toARGB32();
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
    final repository = ref.read(categoryRepositoryProvider);
    try {
      if (widget.existing != null) {
        await repository.update(widget.existing!.copyWith(name: name, iconKey: _iconKey, color: _color));
      } else {
        await repository.create(CategoryEntity(
          id: '',
          name: name,
          type: widget.type,
          iconKey: _iconKey,
          color: _color,
        ));
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existing != null ? 'Edit category' : 'New category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                autofocus: widget.existing == null,
              ),
              const SizedBox(height: 16),
              Text('Icon', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CategoryIcons.map.entries.map((entry) {
                  final selected = entry.key == _iconKey;
                  return InkWell(
                    onTap: () => setState(() => _iconKey = entry.key),
                    borderRadius: BorderRadius.circular(24),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: selected
                          ? Color(_color).withValues(alpha: 0.25)
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Icon(entry.value, color: selected ? Color(_color) : null),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Color', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CategoryColors.palette.map((color) {
                  final value = color.toARGB32();
                  final selected = value == _color;
                  return InkWell(
                    onTap: () => setState(() => _color = value),
                    borderRadius: BorderRadius.circular(18),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: color,
                      child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                    ),
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
      ),
    );
  }
}
