import 'package:flutter/material.dart';
import 'package:prueba/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  static const brandTitle = TextStyle(
    color: AppColors.navy,
    fontFamily: 'Pacifico',
    fontSize: 42,
    height: 1.25,
  );

  static const appBarBrandTitle = TextStyle(
    color: AppColors.navy,
    fontFamily: 'Pacifico',
    fontSize: 30,
    height: 1.2,
  );
}
