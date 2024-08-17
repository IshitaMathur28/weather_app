import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/weather_model.dart';
import 'package:flutter_application_1/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('48bf03076b6255b6f9ee5fa25a48458f');
  Weather? _weather;

  Future<void> _fetchWeather() async {
    try {
      // Get current city
      String cityname = await _weatherService.getCurrentCity();

      // Get weather for city
      final weather = await _weatherService.getWeather(cityname);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _weather = null; // Optionally, set an error state
      });
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json'; // Default animation
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _weather?.cityname ?? "Loading city...",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Lottie.asset(
                  getWeatherAnimation(_weather?.maincondition),
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Text(
                  _weather != null
                      ? '${_weather!.temperature.round()}°C'
                      : 'Loading temperature...',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  _weather?.maincondition ?? "",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
