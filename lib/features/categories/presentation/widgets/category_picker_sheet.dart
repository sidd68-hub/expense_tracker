import 'package:flutter/material.dart';

import '../../../../core/common/constants/category_icons.dart';
import '../../domain/entities/category_entity.dart';

/// Bottom sheet used by the Add/Edit Transaction screen to pick a category.
/// Returns the selected [CategoryEntity], or null if dismissed.
Future<CategoryEntity?> showCategoryPickerSheet(
  BuildContext context, {
  required List<CategoryEntity> categories,
}) {
  return showModalBottomSheet<CategoryEntity>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _CategoryPickerSheet(categories: categories),
  );
}

class _CategoryPickerSheet extends StatelessWidget {
  const _CategoryPickerSheet({required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select category', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (categories.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No categories yet. Add one from Settings → Categories.'),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context, category),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(category.color).withValues(alpha: 0.15),
                            child: Icon(CategoryIcons.iconFor(category.iconKey), color: Color(category.color)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
