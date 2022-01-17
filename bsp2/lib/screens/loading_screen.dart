import 'package:flutter/material.dart';
import '../providers/auth.dart';
import './home.dart';
import './signup.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  static const id = "loading";

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    try {
      await Provider.of<Auth>(context, listen: false)
          .tryAutoLogin(removeWaitTime: false);

      if (Provider.of<Auth>(context, listen: false).isAuth) {
        print("authenticated");
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
      } else {
        print("not authenticated");
        Navigator.pushNamedAndRemoveUntil(context, SignUp.id, (route) => false);
      }
    } catch (e) {
      print(e);
      print("not authenticated");
      Navigator.pushNamedAndRemoveUntil(context, SignUp.id, (route) => false);
      // handle error case by showing snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              // child: Image.asset(
              //   "assets/images/logo.png",
              //   height: 123,
              // ),

              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: const Text(
                  "Labriynth",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "FiraSans",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // letterSpacing: 2,

                    fontSize: 39,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SpinKitRotatingCircle(
                color: Colors.white,
                size: 50.0,
              )
              // CircularProgressIndicator()
              // Image.asset("assets/images/process_loader.gif"),
            ],
          )),
    );
  }
}
