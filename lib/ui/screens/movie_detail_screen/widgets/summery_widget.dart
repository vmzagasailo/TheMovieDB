import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';

class SummeryWidget extends StatelessWidget {
  const SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary =
        context.select((MovieDetailsProvider model) => model.data.summary);

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
        child: Text(
          summary,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}