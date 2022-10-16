import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_routes_names.dart';
import 'package:the_movie_db/ui/screens/loader_screen/cubit/loader_view_cubit.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderScreenState>(
      listenWhen: (previous, current) => current != LoaderScreenState.unknown,
      listener: onLoaderStateChange,
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void onLoaderStateChange(BuildContext context, LoaderScreenState state) {
    final nextScreen = state == LoaderScreenState.authorized
        ? MainNavigationRoutesNames.mainScreen
        : MainNavigationRoutesNames.authScreen;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
