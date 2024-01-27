// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shubham_weather/screens/auth/auth_view.dart';
import 'package:shubham_weather/screens/home/city_list_view.dart';
import 'package:shubham_weather/services/city_fav_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
