import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_routes_names.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreData =
        context.select((MovieDetailsProvider model) => model.data.scoreData);
    final trailerKey = scoreData.trailerKey;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  scoreData.voteAverage.toStringAsFixed(0),
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'User score',
              ),
            ],
          ),
        ),
        if (trailerKey != null)
          Container(
            color: Colors.red,
            width: 1,
            height: 15,
          ),
        if (trailerKey != null)
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(
                MainNavigationRoutesNames.movieTrailerWidget,
                arguments: trailerKey),
            child: Row(
              children: const [
                Icon(Icons.play_arrow),
                Text('Play trailer'),
              ],
            ),
          ),
      ],
    );
  }
}