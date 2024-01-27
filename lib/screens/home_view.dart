import 'package:flutter/material.dart';
import 'package:shubham_weather/constants/constants.dart';
import 'package:shubham_weather/screens/home/city_list_view.dart';
import 'package:shubham_weather/services/city_fav_service.dart';
import 'package:shubham_weather/services/weather_service.dart';
import 'package:weather/weather.dart';

class HomeView extends StatefulWidget {
  final String cityName;
  final FavoritesManager favoritesManager;

  const HomeView({
    Key? key,
    required this.cityName,
    required this.favoritesManager,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _fetchWeatherData() async {
    Weather? weather = await _weatherService.getCurrentWeather(widget.cityName);
    if (weather != null) {
      setState(() {
        _weather = weather;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weather == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _body(),
    );
  }

  Widget _body() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.sort,
              color: Colors.black,
              semanticLabel: 'Menu',
              size: 30,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _openFavoritesScreen(context);
              },
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.black,
                semanticLabel: 'Favorite',
                size: 30,
              ),
            ),
          ],
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            background: _header(),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          Text(
            _weather!.areaName!,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            _weather!.country!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            _weather!.temperature!.celsius!
                .floorToDouble()
                .toString()
                .split('.')[0],
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const Text(
            "Celsius",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "$baseImageUrl${_weather!.weatherIcon!}@2x.png",
                width: 50,
                height: 50,
              ),
              Text(
                _weather!.weatherMain!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openFavoritesScreen(BuildContext context) async {
    setState(() {
      widget.favoritesManager.addFavoriteCity(widget.cityName);
    });
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityListView(
          favoritesManager: widget.favoritesManager,
        ),
      ),
    );
  }
}
