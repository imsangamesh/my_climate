import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../screens/inputScreen.dart';
import '../models/myHttpException.dart';
import '../services/Location.dart';
import '../utilities/constants.dart';
import '../services/weather.dart';

class WeatherScreen extends StatefulWidget {
  static const String routeName = '/location-screen';
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<WeatherScreen> {
  final popupKey = GlobalKey();
  var gotData;
  final location = Location();
  var _isLoading = false;
  int temperature = 0;
  String weatherIcon = '';
  String weatherMessage = "sorry we couldn't find your weather status.";
  String cityName = '';
  String climate;

  Future<void> getLocation() async {
    try {
      setState(() => _isLoading = true);
      await location.getMyLocation(context);
      gotData = await location.getData();
      setState(() => _isLoading = false);
      updateUI(gotData);
    } on MyHttpException catch (error) {
      kshowErrorDialog(error.toString(), 'Enable', context);
    } catch (e) {
      kshowErrorDialog(e.toString(), 'Enable', context);
    }
  }

  void updateUI(gotDataUI) {
    final weatherObj = WeatherModel();
    final receivedData = gotDataUI;
    if (receivedData == null) {
      return;
    }
    setState(() {
      int condition = receivedData['weather'][0]['id'];
      temperature = receivedData['main']['temp'].toInt();
      weatherIcon = weatherObj.getWeatherIcon(condition);
      weatherMessage = weatherObj.getMessage(temperature);
      climate = weatherObj.getClimate(condition);
      cityName = receivedData['name'];
    });
  }

  void triggerModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => InputScreen(updateUI),
    );
  }

  void showPopUp() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(90, 70, 100, 100),
      items: [
        PopupMenuItem(
          child: Container(
            child: Text(
                'please provide a name of a city which is popular in your area to get accurate weather details.'),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                getLocation();
                updateUI(gotData);
              },
              icon: Icon(
                Icons.near_me,
                size: 40.0,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 37.0,
              ),
              onPressed: () {
                showPopUp();
              },
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () => triggerModalBottomSheet(),
                icon: Icon(
                  Icons.location_city,
                  size: 40.0,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black38,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${temperature.toStringAsFixed(0)}°',
                style: kTempTextStyle,
              ),
              Text(
                '🌫',
                style: kConditionTextStyle,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black38,
          ),
          child: Text(
            "$weatherMessage in $cityName !",
            textAlign: TextAlign.right,
            style: kMessageTextStyle,
          ),
        ),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitSpinningLines(
                      lineWidth: 4,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'fetching your location, Please wait!',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        location.getMyLocation(context);
                      },
                      icon: Icon(Icons.add_location_alt_outlined),
                      label: Text('Give Permission'),
                    )
                  ],
                ),
              )
            : Stack(
                children: [
                  Image.asset(
                    'assets/images/$climate.webp',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  column,
                ],
              ),
      ),
    );
  }
}
