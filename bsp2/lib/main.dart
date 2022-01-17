import 'package:bsp2/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/signup.dart';
import './screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Labirynth',
        theme: ThemeData(
            iconTheme: const IconThemeData(color: Colors.deepOrange),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 19),
                elevation: 5,
              ),
            )),
        home: LoadingScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          SignUp.id: (context) => SignUp(),
          Login.id: (context) => Login(),
          Home.id: (context) => Home(),
          LoadingScreen.id: (context) => LoadingScreen(),
        },
      ),
    );
  }
}
