import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/auth_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/api_client/network_client.dart';
import 'package:the_movie_db/domain/blocs/auth/auth_bloc.dart';
import 'package:the_movie_db/domain/blocs/movie_list/movie_list_bloc.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/services/auth_service.dart';
import 'package:the_movie_db/domain/services/movie_service.dart';
import 'package:the_movie_db/library/http_client/app_http_client.dart';
import 'package:the_movie_db/library/secure_storage/secure_storage.dart';
import 'package:the_movie_db/main.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';
import 'package:the_movie_db/ui/screens/app/my_app.dart';
import 'package:the_movie_db/ui/screens/auth/auth_screen.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_cubit.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_state.dart';
import 'package:the_movie_db/ui/screens/loader_screen/cubit/loader_view_cubit.dart';
import 'package:the_movie_db/ui/screens/loader_screen/loader_screen.dart';
import 'package:the_movie_db/ui/screens/main_screen/main_screen.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/movie_details_screen.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/cubit/movie_list_cubit.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/movie_list_screen.dart';
import 'package:the_movie_db/ui/screens/movie_trailer_screen/movie_trailer_screen.dart';
import 'package:the_movie_db/ui/screens/series_screen/series_screen.dart';
import 'package:the_movie_db/ui/screens/series_screen/series_view_model.dart';

AppFactory makeAppFactory() => _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = _DIContainer();
  _AppFactoryDefault();
  @override
  Widget makeApp() => MyApp(navigation: _diContainer._makeMyAppNavigation());
}

class _DIContainer {
  final SecureStorage _secureStorage = const SecureStorageDefault();
  final AppHttpClient _httpClient = AppHttpClientDefault();

  _DIContainer();

  ScreenFactory _makeScreenFactory() => ScreenFactoryDefault(this);
  MyAppNavigation _makeMyAppNavigation() =>
      MainNavigation(_makeScreenFactory());

  SessionDataProvider _makeSessionDataProvider() =>
      SessionDataProviderDefault(_secureStorage);

  NetworkClient _makeNetworkClient() => NetworkClientDefault(_httpClient);

  AuthApiClient _makeAuthApiClient() =>
      AuthApiClientDefault(_makeNetworkClient());

  AccountApiClient _makeAccountApiClient() =>
      AccountApiClientDefault(_makeNetworkClient());

  MovieApiClient _makeMovieApiClient() =>
      MovieApiClientDefault(_makeNetworkClient());

  AuthService _makeAuthService() => AuthServiceDefault(
        accountApiClient: _makeAccountApiClient(),
        authApiClient: _makeAuthApiClient(),
        sessionDataProvider: _makeSessionDataProvider(),
      );
  MovieService _makeMovieService() => MovieService(
        movieApiClient: _makeMovieApiClient(),
        sessionDataProvider: _makeSessionDataProvider(),
        accountApiClient: _makeAccountApiClient(),
      );

  MovieDetailsProvider _makeMovieDetailsModel(int movieId) => MovieDetailsProvider(
        movieId: movieId,
        authService: _makeAuthService(),
        movieDetailsProvider: _makeMovieService(),
      );

  AuthBloc _makeAuthBloc() => AuthBloc(
        initialState: AuthCheckStatusInProgressState(),
        authApiClient: _makeAuthApiClient(),
        accountApiClient: _makeAccountApiClient(),
        sessionDataProvider: _makeSessionDataProvider(),
      );
  AuthViewCubit _makeAuthViewCubit() => AuthViewCubit(
        AuthScreenFormFillInProgressState(),
        _makeAuthBloc(),
      );
  LoaderViewCubit _makeLoaderViewCubit() => LoaderViewCubit(
        LoaderScreenState.unknown,
        _makeAuthBloc(),
      );

  MovieListBloc _makeMovieListBloc() =>
      MovieListBloc(const MovieListState.initial(),
          movieApiClient: _makeMovieApiClient());
}

class ScreenFactoryDefault implements ScreenFactory {
  final _DIContainer _diContainer;
  const ScreenFactoryDefault(this._diContainer);

  @override
  Widget makeLoaderScreen() {
    return BlocProvider<LoaderViewCubit>(
      create: (_) => _diContainer._makeLoaderViewCubit(),
      child: const LoaderScreen(),
    );
  }

  @override
  Widget makeAuthScreen() {
    return BlocProvider<AuthViewCubit>(
      create: (_) => _diContainer._makeAuthViewCubit(),
      child: const AuthScreen(),
    );
  }

  @override
  Widget makeMainScreen() {
    return MainScreen(
      screenFactory: this,
    );
  }

  @override
  Widget makeMovieDetailsScreen(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeMovieDetailsModel(movieId),
      child: const MovieDetailsScreen(),
    );
  }

  @override
  Widget makeTrailerScreen(String youTubeKey) {
    return MovieTrailerScreen(youTubeKey: youTubeKey);
  }

  @override
  Widget makeMovieListScreen() {
    return BlocProvider<MovieListViewCubit>(
      create: (_) => MovieListViewCubit(
        movieListBloc: _diContainer._makeMovieListBloc(),
      ),
      child: const MovieListScreen(),
    );
  }

  @override
  Widget makeSeriesScreen() {
    return ChangeNotifierProvider(
      create: (_) => SeriesViewModel(),
      child: const SeriesScreen(),
    );
  }
}
