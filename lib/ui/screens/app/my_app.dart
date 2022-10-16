import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_routes_names.dart';
import 'package:the_movie_db/ui/theme/app_colors.dart';

abstract class MyAppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MyAppNavigation navigation;
  const MyApp({Key? key, required this.navigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainDarkBlue),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainDarkBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk', 'UA'),
        Locale('en', 'US'),
      ],
      routes: navigation.routes,
      initialRoute: MainNavigationRoutesNames.loaderScreen,
      onGenerateRoute: navigation.onGenerateRoute,
    );
  }
}
