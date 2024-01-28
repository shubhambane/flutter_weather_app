import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shubham_weather/constants/constants.dart';
import 'package:shubham_weather/screens/home/home_view.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? currentCity;

  @override
  void initState() {
    _checkPermissionStatus();
    // _requestLocationPermission();
    super.initState();
  }

  void _searchWeather(String cityName) async {
    Weather? weather = await _weatherService.getCurrentWeather(cityName);

    if (weather != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchController.clear();
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
        _searchController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('City not found'),
          ),
        );
      });
    }
  }

  late PermissionStatus _permissionStatus;

  void _checkPermissionStatus() async {
    PermissionStatus status = await Permission.location.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();

    setState(() {
      _permissionStatus = status;
    });

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          setState(() {
            currentCity = placemark.locality!.toLowerCase();
            if (kDebugMode) {
              print('Current City: $currentCity');
            }
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting location: $e');
        }
      }
      if (kDebugMode) {
        print('Location permission granted');
      }
    } else if (status.isDenied) {
      if (kDebugMode) {
        print('Location permission denied');
      }
    } else if (status.isPermanentlyDenied) {
      if (kDebugMode) {
        print('Location permission permanently denied');
      }
      openAppSettings();
    }
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    if (hour < 21) {
      return 'Good Evening';
    }
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Shubham Weather',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.search,
                controller: _searchController,
                onFieldSubmitted: (value) {
                  if (_formKey.currentState!.validate()) {
                    _searchWeather(
                      value.toLowerCase(),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Search City',
                  hintText: 'Enter city name',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _searchWeather(
                          _searchController.text.toLowerCase(),
                        );
                      }
                    },
                  ),
                  fillColor: const Color(0xFF1B1B1B),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    _requestLocationPermission();
                    if (currentCity != null) {
                      _searchWeather(currentCity!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Current city not found'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.my_location_outlined),
                  label: const Text(
                    'Current City',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Favorites',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            _favList(),
          ],
        ),
      ),
    );
  }

  Widget _favList() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: widget.favoritesManager.favoriteCities.length,
        itemBuilder: (context, index) {
          String cityName = widget.favoritesManager.favoriteCities[index];
          return FutureBuilder<Weather?>(
            future: _weatherService.getCurrentWeather(cityName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Weather? weather = snapshot.data;
                if (weather != null) {
                  return Dismissible(
                    key: Key(cityName),
                    background: Container(
                      color: Colors.red,
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            content: const Text(
                              "Are you sure you wish to delete this city?",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  "DELETE",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeView(
                              cityName: cityName,
                              favoritesManager: widget.favoritesManager,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        padding: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  "$baseImageUrl${weather.weatherIcon!}@2x.png",
                                  width: 50,
                                  height: 50,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: weather.areaName!,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ', ${weather.country!}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${weather.temperature!.celsius!.floorToDouble().toString().split('.')[0]}°",
                                  style: const TextStyle(
                                    fontSize: 52,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
          );
        });
  }
}
