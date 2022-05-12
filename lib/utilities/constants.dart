import 'package:flutter/material.dart';
import '../services/Location.dart';

final location = Location();

const kTempTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
);

const kMessageTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);

const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 100.0,
);

Future kshowErrorDialog(String error, String btnName, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(error),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            location.getMyLocation(context);
            Navigator.of(context).pop();
          },
          label: Text(btnName),
          icon: Icon(Icons.check),
        ),
      ],
    ),
  );
}
