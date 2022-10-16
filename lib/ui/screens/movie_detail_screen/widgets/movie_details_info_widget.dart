import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/description_widget.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/movie_name_widget.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/people_widget.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/score_widget.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/summery_widget.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/top_poster_widget.dart';

class MovieDetailsInfo extends StatelessWidget {
  const MovieDetailsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        TopPosterWidget(),
        Padding(
          padding: EdgeInsets.all(15),
          child: MovieNameWidget(),
        ),
        ScoreWidget(),
        SummeryWidget(),
        Padding(
          padding: EdgeInsets.all(10),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: DescriptionWidget(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: PeopleWidget(),
        ),
      ],
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Overview',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}





