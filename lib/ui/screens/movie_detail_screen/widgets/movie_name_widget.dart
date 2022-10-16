import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';

class MovieNameWidget extends StatelessWidget {
  const MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameData =
        context.select((MovieDetailsProvider model) => model.data.nameData);

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(
          children: [
            TextSpan(
                text: nameData.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
            TextSpan(text: nameData.year, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}