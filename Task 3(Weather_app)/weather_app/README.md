# Weather App
*This is a Flutter-based Weather App that provides real-time weather updates and a 7-day weather forecast. The app includes features like location-based weather retrieval, dynamic UI updates, and a city search functionality. It uses various Flutter packages including http for network requests, geocoding and geolocator for location services, and lottie for animated weather icons.*

## Features
- **Real-Time Weather:** *Fetches current weather data including temperature, description, humidity, wind speed, and more.*
- **7-Day Forecast:** *Displays a 7-day weather forecast with daily temperature, description, and weather animations.*
- **City Search:** *Allows users to search for weather data in different cities.*
- **Location Services:** *Uses geolocation to fetch weather data based on the user's current location.*
- **Dynamic UI:** *Updates the UI with the latest weather data and animations based on weather conditions.*

## Components
- **home_screen.dart:** *Displays current weather data and a button to view the 7-day forecast. Includes a dynamic clock and weather animations.*
- **search_screen.dart:** *Allows users to search for weather data by city and displays the weather information.*
- **next_7_day_weather.dart:** *Shows a detailed 7-day weather forecast using a list view.*
- **weather_model.dart:** *Defines the data structure for weather information.*
- **weather_service.dart:** *Handles API calls to fetch weather data and the user's current city.*
- **card_widget.dart:** *Custom widget for displaying weather details in a card format.*
- **list_style.dart:** *Custom widget for displaying 7-day weather forecast in a list format.*

## Technologies Used
- *Flutter*
- *Dart*
- *Weather API*
- *Lottie*
- *Geocoding & Geolocator*

## How to Run
- *Clone the repository.*
- *Run flutter pub get to install dependencies.*
- *Set up your Weather API key in weather_service.dart.*
- *Use flutter run to start the app.*

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
