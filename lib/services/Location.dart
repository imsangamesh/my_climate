import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/myHttpexception.dart';

class Location {
  static const apiId = '050c08b1def5714ffc078d8a6d6d48c8';
  double latitude;
  double longitude;
  final snackBar = SnackBar(
    content: Text(
        'you should enable your location permission for this app to fetch your location.'),
  );

  Future<void> getMyLocation(BuildContext context) async {
    bool locServiceEnabled;
    LocationPermission permission;
    try {
      locServiceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();

      if (!locServiceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // throw MyHttpException(
        //     'you should enable your location permission for this app to fetch your location.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // throw MyHttpException(
          //     'you have denied your permission, We are helpless to provide our services to you');
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      // getData();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> getData() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiId&units=metric');
    try {
      http.Response response = await http.get(url);
      final decodedData = jsonDecode(response.body);
      if (decodedData == null) {
        throw MyHttpException(
            'we are unable to fetch weather status, please make sure you are connected to network. Or try again after some time.');
      }
      return decodedData;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<dynamic> getMyCityLocation(String cityName) async {
    // {"cod":"404","message":"city not found"}
    // "message": "city not found"

    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiId&units=metric');

      final response = await http.get(url);
      final responseBody = json.decode(response.body);
      if (responseBody['message'] == "city not found") {
        throw MyHttpException(
            'sorry, it seems that your city is out of reach for our services. please try with your districts names.');
      }
      return responseBody;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}


// https://api.openweathermap.org/data/2.5/weather?lat=33&lon=66&appid=050c08b1def5714ffc078d8a6d6d48c8&units=metric

// Future<void> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     try {
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw MyHttpException('you should enable your location permission.');
//       }

//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw MyHttpException(
//               'you should enable your 222 location permission.');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw MyHttpException('you have denied permission forever.');
//       }
//       final position = await Geolocator.getCurrentPosition();
//       latitude = position.latitude;
//       longitude = position.longitude;
//     } catch (e) {
//       print('error================$e');
//       rethrow;
//     }
//   }