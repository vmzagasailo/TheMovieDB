import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/screens/auth/widgets/auth_form_widget.dart';
import 'package:the_movie_db/ui/theme/app_button_style.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 5),
          AuthFormWidget(),
        ],
      ),
    );
  }
}
