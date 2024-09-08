import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/screens/search_screen.dart';
import '../model/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/card_widget.dart';
import 'next_7_day_weaather.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  bool isDarkMode;
  HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService();
  WeatherModel? weatherModel;
  List<dynamic>? forecast;
  DateTime now = DateTime.now();
  String? cityName;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
    fetctNext7DayWeather();
    // Stream to update time every second
    Stream.periodic(const Duration(seconds: 1)).listen((_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  // fetch current location weather
  Future<void> fetchWeatherData() async {
    cityName = await weatherService.getCurrentCity();
    try {
      final weather = await weatherService.fetchCurrentWeather(cityName!);
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

  // fetch current location next 7 day weather
  Future<void> fetctNext7DayWeather() async {
    cityName = await weatherService.getCurrentCity();
    try {
      final forecastData = await weatherService.fetch7DaysForecast(cityName!);
      setState(() {
        forecast = forecastData['forecast']['forecastday'];
      });
    } catch (e) {
      print(e);
    }
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
    String formattedDate = DateFormat('EEEE, d MMMM').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: weatherModel == null
          ? const Center(child: CircularProgressIndicator())
          : buildWeatherContent(formattedDate, formattedTime),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: weatherModel != null
                ? Text(
                    weatherModel!.cityName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text('Fetching...'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchScreen(
                            city: cityName!,
                          )));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: widget.onThemeToggle,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeatherContent(String formattedDate, String formattedTime) {
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
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    getWeatherAsset(weatherModel!.description),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              weatherModel!.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '$formattedDate | $formattedTime',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CardWidget(
                  name: weatherModel!.sunrise,
                  icon: Icons.energy_savings_leaf_sharp,
                  description: 'Pressure',
                ),
                const SizedBox(
                  width: 10,
                ),
                CardWidget(
                  name: '${weatherModel!.feelsLike.toStringAsFixed(1)}°C',
                  icon: Icons.thermostat,
                  description: 'Feels Like',
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Next7DayWeather(forecast: forecast),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next 7 Days'),
                    Icon(Icons.navigate_next_outlined)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
