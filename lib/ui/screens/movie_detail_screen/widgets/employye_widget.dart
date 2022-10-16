import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';

class EmployeeWidget extends StatelessWidget {
  final MovieDetailPeopleData employee;
  const EmployeeWidget({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    const positionStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle),
          Text(employee.job, style: positionStyle),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}