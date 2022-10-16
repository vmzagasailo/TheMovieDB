class MovieListData {
  final int id;
  final String title;
  final String releaseDate;
  final String overview;
  final String? posterPath;

  MovieListData({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.posterPath,
  });
}