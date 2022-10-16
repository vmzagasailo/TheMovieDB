import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/auth/auth_screen.dart';
import 'package:the_movie_db/ui/screens/auth/widgets/auth_button.dart';
import 'package:the_movie_db/ui/screens/auth/widgets/error_widget.dart';
import 'package:the_movie_db/ui/theme/app_button_style.dart';

class AuthFormWidget extends StatelessWidget {
  const AuthFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<AuthDataStorage>();
    const textStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ErrorMessageWidget(),
        const Text(
          'Username',
          style: textStyle,
        ),
        TextField(
          decoration: textFieldDecorator,
          onChanged: (text) => authDataStorage.login = text,
        ),
        const Text(
          'Password',
          style: textStyle,
        ),
        TextField(
          decoration: textFieldDecorator,
          obscureText: true,
          onChanged: (text) => authDataStorage.password = text,
        ),
        const SizedBox(height: 25),
       const AuthButtonWidget(),
      ],
    );
  }
}
