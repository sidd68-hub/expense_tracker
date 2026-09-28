import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/constants/category_icons.dart';
import '../../../../core/common/widgets/state_views.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/category_type.dart';
import '../controllers/category_providers.dart';
import '../widgets/category_edit_sheet.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _addCategory(CategoryType type) async {
    await showCategoryEditSheet(context, type: type);
  }

  Future<void> _editCategory(CategoryEntity category) async {
    await showCategoryEditSheet(context, type: category.type, existing: category);
  }

  Future<void> _archiveOrDelete(CategoryEntity category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove "${category.name}"?'),
        content: const Text(
          'If this category is used by any transactions it will be archived instead of deleted, so your history stays intact.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(categoryRepositoryProvider).delete(category.id);
    }
  }

  Widget _buildList(AsyncValue<List<CategoryEntity>> categoriesAsync, CategoryType type) {
    return categoriesAsync.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(message: error.toString()),
      data: (categories) {
        if (categories.isEmpty) {
          return EmptyView(
            icon: Icons.category_outlined,
            title: 'No ${type.name} categories yet',
            action: FilledButton(onPressed: () => _addCategory(type), child: const Text('Add category')),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(category.color).withValues(alpha: 0.15),
                child: Icon(CategoryIcons.iconFor(category.iconKey), color: Color(category.color)),
              ),
              title: Text(category.name),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') _editCategory(category);
                  if (value == 'remove') _archiveOrDelete(category);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseCategories = ref.watch(expenseCategoriesProvider);
    final incomeCategories = ref.watch(incomeCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'Expense'), Tab(text: 'Income')]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(expenseCategories, CategoryType.expense),
          _buildList(incomeCategories, CategoryType.income),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCategory(_tabController.index == 0 ? CategoryType.expense : CategoryType.income),
        child: const Icon(Icons.add),
      ),
    );
  }
}
