import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/cubit/movie_list_cubit.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/widgets/movie_list_item.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieListViewCubit>();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 70),
      itemExtent: 163,
      itemCount: cubit.state.movies.length,
      itemBuilder: (BuildContext context, int index) {
        cubit.showedMovieAtIndex(index);
        return MovieListItem(
          index: index,
        );
      },
    );
  }
}