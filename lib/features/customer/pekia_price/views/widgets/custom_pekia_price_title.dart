import 'package:flutter/material.dart';
import 'package:green_loop/core/utilies/colors/app_colors.dart';
import 'package:green_loop/core/utilies/extensions/app_extensions.dart';
import 'package:green_loop/core/utilies/styles/app_text_styles.dart';

class CustomPekiaPriceTitle extends StatelessWidget {
  const CustomPekiaPriceTitle({
    super.key,
    required this.title,
    this.color,
  });
  final String title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: context.width * 0.18,
        decoration: BoxDecoration(
          color: color?.withValues(alpha: .7) ??
              AppColors.secondryColor.withValues(alpha: .8),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.title20WhiteBold,
          ),
        ),
      ),
    );
  }
}
