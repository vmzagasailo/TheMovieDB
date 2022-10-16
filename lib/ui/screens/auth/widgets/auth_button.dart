import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/auth/auth_screen.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_cubit.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_state.dart';

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AuthViewCubit>();
    final authDataStorage = context.read<AuthDataStorage>();
    const color = Color(0xFF01B4E4);
    final canStartAuth = cubit.state is AuthScreenFormFillInProgressState ||
        cubit.state is AuthViewCubitErrorState;
    final onPressed = canStartAuth
        ? () => cubit.auth(
              login: authDataStorage.login,
              password: authDataStorage.password,
            )
        : null;
    final child = cubit.state is AuthViewCubitAuthProgressState
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Login');
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
        ),
      ),
      child: child,
    );
  }
}