import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/widgets/employye_widget.dart';

class EmployeeRowWidget extends StatelessWidget {
  final List<MovieDetailPeopleData> employee;
  const EmployeeRowWidget({Key? key, required this.employee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: employee
          .map((employee) => EmployeeWidget(
                employee: employee,
              ))
          .toList(),
    );
  }
}