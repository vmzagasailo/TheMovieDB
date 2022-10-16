import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:the_movie_db/domain/api_client/api_client_exception.dart';
import 'package:the_movie_db/domain/entity/movie/movie_details/movie_details.dart';
import 'package:the_movie_db/domain/local_entity/movie_details/movie_details_local.dart';
import 'package:the_movie_db/domain/services/auth_service.dart';
import 'package:the_movie_db/library/widgets/localized_model.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_actions.dart';

abstract class MovieDetailsModelMovieProvider {
  Future<MovieDetailsLocal> loadMovieDetails({
    required int movieId,
    required String locale,
  });

  Future<void> updateFavorite({
    required bool isFavorite,
    required int movieId,
  });
}

class MovieDetailsProvider extends ChangeNotifier {
  final AuthService authService;
  final MovieDetailsModelMovieProvider movieDetailsProvider;

  final _localeStorage = LocalizedModelStorage();
  int movieId;
  late DateFormat _dateFormat;
  final data = MovieDetailsData();

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  MovieDetailsProvider({
    required this.movieId,
    required this.authService,
    required this.movieDetailsProvider,
  });

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    updateData(null, false);
    await _loadMovieDetails(context);
  }

  void updateData(MovieDetails? movieDetails, bool isFavorite) {
    data.title = movieDetails?.title ?? 'Loading';
    data.isLoading = movieDetails == null;
    if (movieDetails == null) {
      notifyListeners();
      return;
    }
    data.overview = movieDetails.overview ?? '';
    data.posterData = MovieDetailsPosterData(
      posterPath: movieDetails.posterPath,
      backdropPath: movieDetails.backdropPath,
      isFavorite: isFavorite,
    );
    var year = movieDetails.releaseDate?.year;
    data.nameData = MovieDetailsNameData(
      name: movieDetails.title,
      year: ' ($year)',
    );
    final videos = movieDetails.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : '';
    var voteAverage = movieDetails.voteAverage * 10;
    data.scoreData =
        MovieDetailsScoreData(voteAverage: voteAverage, trailerKey: trailerKey);
    data.summary = makeSummary(movieDetails);
    data.peopleData = makePeopleData(movieDetails);
    data.actorData = movieDetails.credits.cast
        .map((e) => MovieDetailsActorData(
            name: e.name, character: e.character, profilePath: e.profilePath))
        .toList();
    notifyListeners();
  }

  String makeSummary(MovieDetails? movieDetails) {
    var texts = <String>[];
    final releaseDate = movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(stringFromDate(releaseDate));
    }
    final productionCountries = movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }
    final runtime = movieDetails?.runtime;
    if (runtime != null) {
      final duration = Duration(minutes: runtime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      texts.add('${hours}h ${minutes}m');
    }
    final genres = movieDetails?.genres;
    var genresName = <String>[];
    if (genres != null) {
      for (var genr in genres) {
        genresName.add(genr.name);

        texts.add(genresName.join(', '));
      }
    }
    return texts.join(' ');
  }

  List<List<MovieDetailPeopleData>> makePeopleData(MovieDetails? movieDetails) {
    var crewChunks = <List<MovieDetailPeopleData>>[];
    var crew = movieDetails?.credits.crew
        .map((e) => MovieDetailPeopleData(name: e.name, job: e.job))
        .toList();
    if (crew != null && crew.isNotEmpty) {
      crew = crew.length > 4 ? crew.sublist(0, 4) : crew;

      for (var i = 0; i < crew.length; i += 2) {
        crewChunks.add(
          crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
        );
      }
    }
    return crewChunks;
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData =
        data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    notifyListeners();
    try {
      await movieDetailsProvider.updateFavorite(
          isFavorite: data.posterData.isFavorite, movieId: movieId);
    } on ApiClientException catch (e) {
      Future.delayed(const Duration(seconds: 1), () {
        _handleApiClientException(e, context);
      });
    }
  }

  Future<void> _loadMovieDetails(BuildContext context) async {
    try {
      final details = await movieDetailsProvider.loadMovieDetails(
          movieId: movieId, locale: _localeStorage.localeTag);

      updateData(details.movieDetails, details.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.typeError) {
      case ApiClientExceptionType.sessionExpired:
        authService.logout();
        MainNavigationAction.instance.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}

class MovieDetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;

  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailsPosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsNameData {
  final String name;
  final String year;
  MovieDetailsNameData({
    required this.name,
    required this.year,
  });
}

class MovieDetailsScoreData {
  final String? trailerKey;
  final double voteAverage;

  MovieDetailsScoreData({this.trailerKey, required this.voteAverage});
}

class MovieDetailPeopleData {
  final String name;
  final String job;

  MovieDetailPeopleData({required this.name, required this.job});
}

class MovieDetailsActorData {
  final String name;
  final String character;
  final String? profilePath;

  MovieDetailsActorData(
      {required this.name, required this.character, required this.profilePath});
}

class MovieDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData(isFavorite: false);
  MovieDetailsNameData nameData = MovieDetailsNameData(name: '', year: '');
  MovieDetailsScoreData scoreData =
      MovieDetailsScoreData(voteAverage: 0, trailerKey: '');
  String summary = '';
  List<List<MovieDetailPeopleData>> peopleData =
      const <List<MovieDetailPeopleData>>[];
  List<MovieDetailsActorData> actorData = const <MovieDetailsActorData>[];
}
