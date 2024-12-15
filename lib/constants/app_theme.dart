import 'package:flutter/material.dart';

import 'app_colors.dart';

class MyAppThemes {
  
  //Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColorLight,
    secondaryHeaderColor: AppColors.textColorInsteadOfWhite,
    primaryColorLight: AppColors.greyColor,
    splashColor: AppColors.primaryColorLight,
    scaffoldBackgroundColor: AppColors.primaryColorLight,
    indicatorColor:AppColors.darkgrey ,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColorLight,
      iconTheme: IconThemeData(color: AppColors.textColorInsteadOfWhite),
      titleTextStyle: TextStyle(color: AppColors.textColorInsteadOfWhite),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textColorInsteadOfWhite),
      bodyMedium: TextStyle(color: AppColors.darkgrey),
    ),
    iconTheme: const IconThemeData(color:AppColors.textColorInsteadOfWhite),
     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColorLight, 
      selectedItemColor: AppColors.blueColor, 
      unselectedItemColor: AppColors.searchColor, 
    ),
  );



  //Dark Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:  AppColors.primaryColor,
    secondaryHeaderColor: AppColors.whiteColor,
    primaryColor: AppColors.primaryColor,
    splashColor: AppColors.primaryColor,
    primaryColorLight: AppColors.backgroundSearch,
    indicatorColor:AppColors.darkgrey ,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.whiteColor),
      bodyMedium: TextStyle(color: AppColors.greyColor),
    ),
    iconTheme: const IconThemeData(color: AppColors.whiteColor),
       bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor, 
      selectedItemColor: AppColors.blueColor, 
      unselectedItemColor: AppColors.searchColor, 
    ),
  );
}
