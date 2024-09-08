import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ListStyle extends StatelessWidget {
  final String day;
  final String date;
  final String degree;
  final String description;
  ListStyle({super.key, required this.day, required this.date, required this.degree, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0,),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [

            SizedBox(
              width: 70,
              height: 70,
              child: Lottie.asset(getWeatherAsset(description),),
            ),

            const SizedBox(width: 10,),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('$day - $date - $degree°C'),

                const SizedBox(height: 10,),

                Text(description),
              ],
            )

          ],
        ),
      ),
    );
  }

  String getWeatherAsset(String description) {
    if (description.toLowerCase().contains('sunny')) {
      return 'assets/icons/sunny.json';
    } else if (description.toLowerCase().contains('cloud')) {
      return 'assets/icons/cloudy.json';
    } else if (description.toLowerCase().contains('rain')) {
      return 'assets/icons/raining.json';
    } else if (description.toLowerCase().contains('thunder')) {
      return 'assets/icons/thunder.json';
    } else {
      return 'assets/icons/sunny.json';
    }
  }

}
