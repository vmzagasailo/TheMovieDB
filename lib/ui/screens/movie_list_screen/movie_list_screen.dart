import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/cubit/movie_list_cubit.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/widgets/movie_list_widget.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/widgets/search_widget.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  void didChangeDependencies() {
    final locale = Localizations.localeOf(context);
    context.watch<MovieListViewCubit>().setupLocale(locale.languageCode);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        MovieListWidget(),
        SearchWidget(),
      ],
    );
  }
}