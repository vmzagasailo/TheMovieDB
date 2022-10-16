import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_routes_names.dart';

class MainNavigationAction {
  static const instance = MainNavigationAction._();
  const MainNavigationAction._();

  void resetNavigation(BuildContext context) {
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRoutesNames.loaderScreen);
  }
}
