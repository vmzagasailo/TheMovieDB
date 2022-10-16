import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/api_client/image_down_loader.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_routes_names.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/cubit/movie_list_cubit.dart';

class MovieListItem extends StatelessWidget {
  final int index;

  const MovieListItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieListViewCubit>();
    final movie = cubit.state.movies[index];
    final posterPath = movie.posterPath;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ]),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (posterPath != null)
                  Image.network(
                    ImageDownLoader.imageUrl(posterPath),
                    width: 95,
                  ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        movie.releaseDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: () => _onMovieTap(context, movie.id),
              ))
        ],
      ),
    );
  }

  void _onMovieTap(BuildContext context, int movieId) {
    Navigator.of(context).pushNamed(
      MainNavigationRoutesNames.movieDetailScreen,
      arguments: movieId,
    );
  }
}