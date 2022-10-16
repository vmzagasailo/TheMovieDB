import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/navigation/main_navigation_actions.dart';
import 'package:the_movie_db/ui/screens/auth/widgets/header_widget.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_cubit.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_state.dart';

class AuthDataStorage {
  String login = '';
  String password = '';
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthViewCubitState>(
      listener: _onAuthStateChange,
      child: Provider(
        create: (_) => AuthDataStorage(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Login to your account')),
          resizeToAvoidBottomInset: false,
          body: const HeaderWidget(),
        ),
      ),
    );
  }

  void _onAuthStateChange(BuildContext context, AuthViewCubitState state) {
    if (state is AuthViewCubitSuccessAuthState) {
      MainNavigationAction.instance.resetNavigation(context);
    }
  }
}