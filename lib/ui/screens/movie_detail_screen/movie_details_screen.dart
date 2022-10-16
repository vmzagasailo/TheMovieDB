import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/movie_details_cast_widget.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/movie_details_info_widget.dart';
import 'package:provider/provider.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void didChangeDependencies() {
    final locale = Localizations.localeOf(context);
    Future.microtask(
      () => context.read<MovieDetailsProvider>().setupLocale(context, locale),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _Title(),
        centerTitle: true,
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((MovieDetailsProvider value) => value.data.title);
    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((MovieDetailsProvider model) => model.data.isLoading);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsInfo(),
        MovieDetailCastWidget(),
      ],
    );
  }
}
