import 'package:the_movie_db/domain/entity/movie/movie_details/movie_details.dart';

class MovieDetailsLocal {
  final MovieDetails movieDetails;
  final bool isFavorite;

  MovieDetailsLocal({required this.movieDetails,required this.isFavorite});
}