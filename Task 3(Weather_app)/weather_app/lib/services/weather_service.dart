import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';


class WeatherService{
  final String apiKey = '2f01dc20d7fe48b6893123418240109';
  final String forecastBaseUrl = 'http://api.weatherapi.com/v1/forecast.json';
  final String searchBaseUrl = 'http://api.weatherapi.com/v1/forecast.json';

  Future<WeatherModel> fetchCurrentWeather(String city) async{
    final url = '$forecastBaseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      return WeatherModel.fromJson(jsonDecode(response.body), city);
    }else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetch7DaysForecast(String city) async{
    final url = '$forecastBaseUrl?key=$apiKey&q=$city&days=7&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      return json.decode(response.body);
    }else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemark[0].locality;

    return city ?? '';
  }


}