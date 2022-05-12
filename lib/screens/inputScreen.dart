import 'package:flutter/material.dart';
import '../models/myHttpException.dart';
import '../services/Location.dart';
import '../utilities/constants.dart';

class InputScreen extends StatefulWidget {
  InputScreen(this.updateUIofCity);
  Function updateUIofCity;
  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final location = Location();
  var cityName;

  void _setstate(String value) {
    setState(() {
      cityName = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 5,
          right: 5,
          left: 5,
          bottom: mediaQuery.viewInsets.bottom + 5,
        ),
        child: Card(
          elevation: 10,
          color: const Color.fromARGB(234, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'eg:  Paris',
                    labelText: 'city name',
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (value) => _setstate(value),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: cityName == null || cityName == ''
                      ? null
                      : () async {
                          try {
                            final gotData =
                                await location.getMyCityLocation(cityName);
                            widget.updateUIofCity(gotData);
                          } on MyHttpException catch (error) {
                            Navigator.of(context).pop();
                            kshowErrorDialog(error.toString(), 'Ok', context);
                          } catch (err) {
                            Navigator.of(context).pop();
                            await kshowErrorDialog(
                                err.toString(), 'Okhh', context);
                          }
                          Navigator.of(context).pop();
                        },
                  label: Text('search'),
                  icon: Icon(Icons.location_on_outlined),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// on MyHttpException catch (e) {
//                       print('-------------http----------------');
//                       Navigator.of(context).pop();
//                       await kshowErrorDialog(e.toString(), 'Ok', context);
//                     }'sorry, something went wrong.'