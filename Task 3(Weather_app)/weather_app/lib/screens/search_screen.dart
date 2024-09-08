import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

import '../widgets/card_widget.dart';

class SearchScreen extends StatefulWidget {
  final String city;
  SearchScreen({super.key, required this.city});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController cityController = TextEditingController();
  WeatherService weatherService = WeatherService();
  WeatherModel? weatherModel;
  late String cityName;

  @override
  void initState() {
    super.initState();
    cityName = widget.city;
    fetchCityWeather();
  }

  Future<void> fetchCityWeather() async {
    try {
      final weather = await weatherService.fetchCurrentWeather(cityName);
      setState(() {
        weatherModel = weather;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch weather data')),
      );
    }
  }

  // Function to display the dialog box and update the title
  Future<void> showCityNameDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('Enter City Name'),
          content: TextField(
            controller: cityController,
            decoration: const InputDecoration(hintText: "Enter new city name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEEEFF5)
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEEEFF5)
              ),
              onPressed: () {
                setState(() {
                  cityName = cityController.text;
                  cityController.clear();
                });
                Navigator.of(context).pop();
                fetchCityWeather();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: weatherModel == null
          ? const Center(child: CircularProgressIndicator())  // Show loading while fetching
          : buildWeatherContent()
    );
  }

  AppBar appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: GestureDetector(
        onTap: () => showCityNameDialog(),  // Open dialog on title tap
        child: Text(cityName),
      ),
    );
  }

  Widget buildWeatherContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${weatherModel!.currentTemp}°C",
                  style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),

                const SizedBox(width: 10,),

                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(getWeatherAsset(weatherModel!.description),),
                )
              ],
            ),

            const SizedBox(height: 20,),

            Text(
              weatherModel!.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CardWidget(
                  name: weatherModel!.sunrise,
                  icon: Icons.wb_sunny,
                  description: 'Sunrise',
                ),

                CardWidget(
                  name: weatherModel!.sunset,
                  icon: Icons.nights_stay,
                  description: 'Sunset',
                ),

                CardWidget(
                  name: '${weatherModel!.humidity.toStringAsFixed(0)}%',
                  icon: Icons.opacity,
                  description: 'Humidity',
                ),
              ],
            ),

            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                CardWidget(
                  name: '${weatherModel!.windSpeed.toStringAsFixed(1)} Km/h',
                  icon: Icons.wind_power_rounded,
                  description: 'Wind',
                ),

                CardWidget(
                  name: '${weatherModel!.minTemp.toStringAsFixed(1)}°C',
                  icon: Icons.thermostat,
                  description: 'Min temp',
                ),

                CardWidget(
                  name: '${weatherModel!.maxTemp.toStringAsFixed(1)}°C',
                  icon: Icons.thermostat,
                  description: 'Max temp',
                ),
              ],
            ),

            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                CardWidget(
                  name: weatherModel!.sunrise,
                  icon: Icons.energy_savings_leaf_sharp,
                  description: 'Pressure',
                ),

                const SizedBox(width: 10,),

                CardWidget(
                  name: '${weatherModel!.feelsLike.toStringAsFixed(1)}°C',
                  icon: Icons.thermostat,
                  description: 'Feels Like',
                ),
              ],
            ),

            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
