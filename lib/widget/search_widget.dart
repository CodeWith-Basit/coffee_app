import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String text;
  const SearchWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.latteMist,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.burntCaramel),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.trending_up_outlined,
            color: AppColors.burntCaramel,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColors.burntCaramel),
          ),
        ],
      ),
    );
  }
}
