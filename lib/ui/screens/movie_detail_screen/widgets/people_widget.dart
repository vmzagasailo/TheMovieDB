import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/employye_row_widget.dart';

class PeopleWidget extends StatelessWidget {
  const PeopleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crewChunks =
        context.select((MovieDetailsProvider model) => model.data.peopleData);

    return Column(
      children: crewChunks
          .map((chunk) => EmployeeRowWidget(
                employee: chunk,
              ))
          .toList(),
    );
  }
}
