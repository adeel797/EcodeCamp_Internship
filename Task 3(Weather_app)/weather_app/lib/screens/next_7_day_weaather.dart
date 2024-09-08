import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/list_style.dart';

class Next7DayWeather extends StatelessWidget {
  List<dynamic>? forecast;

  Next7DayWeather({super.key,required this.forecast,});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Next 7 Day Weather'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (context, index) {
          final day = forecast![index];
          DateTime date = DateTime.parse(day['date']);
          String dayOfWeek = DateFormat('EEEE').format(date);
          String datea = day['date'];
          String degree = day['day']['avgtemp_c'].round().toString();
          String description = day['day']['condition']['text'].toString();

          return Padding(
            padding: EdgeInsets.all(10),
            child: ListStyle(
              date: datea,
              day: dayOfWeek,
              description: description,
              degree: degree,
            ),
          );
        },
      ),
    );
  }
}