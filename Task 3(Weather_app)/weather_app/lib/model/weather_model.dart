class WeatherModel {
  final String cityName;
  final double currentTemp;
  final String description;
  final double pressure;
  final double humidity;
  final double windSpeed;
  final double minTemp;
  final double maxTemp;
  final double feelsLike;
  final dynamic sunrise;
  final dynamic sunset;

  WeatherModel( {
    required this.cityName,
    required this.currentTemp,
    required this.description,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String cityName) {
    return WeatherModel(
      cityName: cityName,
      currentTemp: json['current']['temp_c']?.toDouble() ?? 0.0,
      description: json['current']['condition']['text'] ?? '',
      pressure: json['current']['pressure_mb']?.toDouble() ?? 0.0,
      humidity: json['current']['humidity']?.toDouble() ?? 0.0,
      windSpeed: json['current']['wind_kph']?.toDouble() ?? 0.0,
      minTemp: json['forecast']['forecastday'][0]['day']['mintemp_c']?.toDouble() ?? 0.0,
      maxTemp: json['forecast']['forecastday'][0]['day']['maxtemp_c']?.toDouble() ?? 0.0,
      feelsLike: json['current']['feelslike_c']?.toDouble() ?? 0.0,
      sunrise: json['forecast']['forecastday'][0]['astro']['sunrise'],
      sunset: json['forecast']['forecastday'][0]['astro']['sunset'],
    );
  }
}



