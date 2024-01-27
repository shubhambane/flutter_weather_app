// city_list_view.dart

import 'package:flutter/material.dart';
import 'package:shubham_weather/screens/home_view.dart';
import 'package:shubham_weather/services/city_fav_service.dart';
import 'package:shubham_weather/services/weather_service.dart';
import 'package:weather/weather.dart';

class CityListView extends StatefulWidget {
  final FavoritesManager favoritesManager;

  const CityListView({Key? key, required this.favoritesManager})
      : super(key: key);

  @override
  State<CityListView> createState() => _CityListViewState();
}

class _CityListViewState extends State<CityListView> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();

  void _searchWeather(String cityName) async {
    Weather? weather = await _weatherService.getCurrentWeather(cityName);

    if (weather != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              cityName: cityName,
              favoritesManager: widget.favoritesManager,
            ),
          ),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('City not found'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search City',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _searchWeather(_searchController.text);
            },
            child: const Text('Search'),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.favoritesManager.favoriteCities.length,
            itemBuilder: (context, index) {
              String cityName = widget.favoritesManager.favoriteCities[index];
              return ListTile(
                title: Text(cityName),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    setState(() {
                      widget.favoritesManager.removeFavoriteCity(cityName);
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
