import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/cubit/movie_list_cubit.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieListViewCubit>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onChanged: cubit.searchMovie,
        decoration: InputDecoration(
            label: const Text('Search'),
            filled: true,
            fillColor: Colors.white.withAlpha(135),
            border: const OutlineInputBorder()),
      ),
    );
  }
}