import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:green_loop/core/utilies/colors/app_colors.dart';
import 'package:green_loop/core/utilies/styles/app_text_styles.dart';
import 'package:green_loop/features/customer/category_details/models/category_products_model.dart';

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
    required this.isSelected,
    required this.categoryProductsModel,
  });

  final bool isSelected;
  final CategoryProductsModel categoryProductsModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.secondryColor, width: 3),
      ),
      color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.3) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                categoryProductsModel.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              categoryProductsModel.name.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isSelected
                  ? AppTextStyles.title20WhiteW500
                  : AppTextStyles.title20PrimaryColorW500,
            ),
          )
        ],
      ),
    );
  }
}
