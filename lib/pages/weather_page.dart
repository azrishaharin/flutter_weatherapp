import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('YOUR API KEY HERE');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print(cityName);

    try {
      final weather = await _weatherService.getWeather(cityName);
      print(weather);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('unable to fetch weather: $e');
    }
  }

  // weather animations
  getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // city name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 10),
              Text(_weather?.cityName ?? 'Loading city...'),
            ],
          ),
          const SizedBox(height: 50),
          // animation
          Lottie.asset(
            getWeatherAnimation(_weather?.weatherCondition),
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 50),
          // temperature
          Text('${_weather?.temperature.round()}°C',
              style: const TextStyle(fontSize: 50)),
          //weather condition
          const SizedBox(height: 10),
          Text(_weather?.weatherCondition ?? 'Loading weather...'),
        ]),
      ),
    );
  }
}
