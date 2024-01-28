// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shubham_weather/screens/auth/auth_view.dart';
import 'package:shubham_weather/screens/home/city_list_view.dart';
import 'package:shubham_weather/services/city_fav_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: FullScreenWidget(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/offline.json',
                height: 200,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Text(
                'No Internet',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            },
            child: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
        ),
      ),
      // ignore: avoid_print

      whenOffline: () => ScaffoldMessenger(
        child: SnackBar(
          content: Text('No Internet'),
        ),
      ),
      // ignore: avoid_print
      whenOnline: () => ScaffoldMessenger(
        child: SnackBar(
          content: Text('Internet is back'),
        ),
      ),
      loadingWidget: const Center(child: Text('Loading')),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CityListView(
                favoritesManager: FavoritesManager(),
              );
            } else {
              return const AuthView();
            }
          },
        ),
      ),
    );
  }
}
