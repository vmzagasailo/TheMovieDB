

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_cubit.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_state.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewCubit c) {
      final state = c.state;
      return state is AuthViewCubitErrorState ? state.errorMessage : null;
    });

    if (errorMessage == null) return const SizedBox.shrink();
    return Text(
      errorMessage,
      style: const TextStyle(color: Colors.red),
    );
  }
}