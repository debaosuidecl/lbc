import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './platformspecific.dart';

showErrorDialog(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) => PlatformSpecific(
            ios: CupertinoAlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
            android: AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
          ));
}
