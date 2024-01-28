// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    _fetchForecastData();
  }

  void _fetchWeatherData() async {
    Weather? weather = await _weatherService.getCurrentWeather(widget.cityName);
    if (weather != null) {
      setState(() {
        _weather = weather;
      });
    } else {}
  }

  // void _fetchForecastData() async {
  //   List<Weather> forecast =
  //       await _weatherService.getForecastWeather(widget.cityName);
  //   setState(() {
  //     _forecast = forecast;
  //   });
  // }

  Future<List<Weather>> _fetchForecastData() async {
    List<Weather> forecast =
        await _weatherService.getForecastWeather(widget.cityName);
    return forecast;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              semanticLabel: 'back',
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
          title: _weather?.areaName != null && _weather?.country != null
              ? RichText(
                  text: TextSpan(
                    text: _weather?.areaName!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: ', ${_weather?.country!}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ),
        body: _weather == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _body(),
      ),
    );
  }

  Widget _body() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: _header(),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1B1B1B),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('7-DAY FORECAST'),
                FutureBuilder<List<Weather>>(
                  future: _fetchForecastData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LinearProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          Weather forecastItem = snapshot.data![index];
                          return _forecastItemCard(forecastItem);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _forecastItemCard(Weather forecastItem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            "$baseImageUrl${forecastItem.weatherIcon!}@2x.png",
            width: 50,
            height: 50,
          ),
          RichText(
            text: TextSpan(
              text: DateFormat('hh:mm a').format(forecastItem.date!),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '\n${DateFormat('D MMM').format(forecastItem.date!)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            "${forecastItem.temperature!.celsius!.floorToDouble().toString().split('.')[0]}°",
            style: TextStyle(
              fontSize: 42,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          RichText(
            text: TextSpan(
              text:
                  "${_weather!.temperature!.celsius!.floorToDouble().toString().split('.')[0]}°",
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'C',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Text(
          //   _weather!.temperature!.celsius!
          //       .floorToDouble()
          //       .toString()
          //       .split('.')[0],
          //   style: const TextStyle(
          //     fontSize: 72,
          //     fontWeight: FontWeight.w900,
          //     color: Colors.black,
          //   ),
          // ),
          // const Text(
          //   "Celsius",
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.w500,
          //     color: Colors.black,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Lat: ${_weather?.latitude?.toString()} Long: ${_weather?.longitude?.toString()}",
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
