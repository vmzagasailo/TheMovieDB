import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_routes_names.dart';
import 'package:the_movie_db/ui/screens/app/my_app.dart';

abstract class ScreenFactory {
  Widget makeLoaderScreen();
  Widget makeAuthScreen();
  Widget makeMainScreen();
  Widget makeMovieDetailsScreen(int movieId);
  Widget makeTrailerScreen(String youTubeKey);
  Widget makeMovieListScreen();
  Widget makeSeriesScreen();
}

class MainNavigation implements MyAppNavigation {
  final ScreenFactory screenFactory;

  const MainNavigation(this.screenFactory);

  @override
  Map<String, Widget Function(BuildContext)> get routes =>
      <String, Widget Function(BuildContext)>{
        MainNavigationRoutesNames.loaderScreen: (_) =>
            screenFactory.makeLoaderScreen(),
        MainNavigationRoutesNames.authScreen: (_) =>
            screenFactory.makeAuthScreen(),
        MainNavigationRoutesNames.mainScreen: (_) =>
            screenFactory.makeMainScreen(),
      };

  @override
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutesNames.movieDetailScreen:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => screenFactory.makeMovieDetailsScreen(movieId),
        );
      case MainNavigationRoutesNames.movieTrailerWidget:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => screenFactory.makeTrailerScreen(youTubeKey),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}
