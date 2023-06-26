import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:stuverse_app/app/core/models/product_category.dart';
import 'package:stuverse_app/app/search/views/search_screen.dart';
import 'package:stuverse_app/utils/common_utils.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.onPressed,
  });

  final ProductCategory category;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
          label: Text(category.name),
          selected: false,
          onSelected: (v) {
            onPressed();
          }),
    );
  }
}
