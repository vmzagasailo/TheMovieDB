import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/api_client/image_down_loader.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';

class TopPosterWidget extends StatelessWidget {
  const TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsProvider>();
    final posterData =
        context.select((MovieDetailsProvider model) => model.data.posterData);
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image(
              image: NetworkImage(ImageDownLoader.imageUrl(backdropPath)),
            ),
          if (posterPath != null)
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image(
                image: NetworkImage(ImageDownLoader.imageUrl(posterPath)),
              ),
            ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () => model.toggleFavorite(context),
              icon: Icon(
                  posterData.isFavorite == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}