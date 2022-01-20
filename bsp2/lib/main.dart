import 'package:bsp2/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import './screens/home.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telephony/telephony.dart';
import 'package:websocket_manager/websocket_manager.dart';

import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/signup.dart';
import './screens/login.dart';

void callbackdispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // initConnect();
    print("Connecting to my service on main new");
//
    var socket = IO.io("wss://homesimb.powersms.land", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      "query": "userid=61dc842b9256020016670749"
    });

    socket.connect();
    socket.onConnect((data) async {
      print("connected to socket on main!!!!!");
      // await Provider.of<Auth>(context, listen: false).pingserver();
    });
    socket.on("sendmsg", (data) {
      print(data);
      // print('data from server');
      if (data != null) {
        String message = data['message'];
        String phone = data['phone'];
        print("sendsms");

        _sendsms(
          phone,
          message,
          socket,
        );
      }
    });

    await Future.delayed(Duration(days: 10000));
    return Future.value(true);
  });
}

void initConnect() {
  // print("Connecting to my service on main");

  var socket = IO.io("wss://homesimb.powersms.land/", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    "query": "userid=61dc842b9256020016670749"
  });

  socket.connect();
  socket.onConnect((data) async {
    print("connected to socket on main");
    // await Provider.of<Auth>(context, listen: false).pingserver();
  });

  socket.on("sendmsg", (data) {
    print(data);
    // print('data from server');
    if (data != null) {
      String message = data['message'];
      String phone = data['phone'];
      print("sendsms");

      // _sendsms(
      //   phone,
      //   message,
      //   socket,
      // );
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(callbackdispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask(
    "socket_worker_process",
    "socket_task",
  );
//   int messageNum = 0;
// // Configure WebSocket url
//   final socket = WebsocketManager('wss://homesimb.powersms.land/');
// // Listen to close message
//   socket.onClose((dynamic message) {
//     print('close');
//   });
// // Listen to server messages
//   socket.onMessage((dynamic message) {
//     print('recv: $message');
//     if (messageNum == 10) {
//       socket.close();
//     } else {
//       messageNum += 1;
//       final String msg = '$messageNum: ${DateTime.now()}';
//       print('send: $msg');
//       socket.send(msg);
//     }
//   });
// // Connect to server
//   socket.connect();
  runApp(MyApp());
}

final Telephony telephony = Telephony.instance;

void listener(SendStatus status, IO.Socket socket) {
  // Handle the status
  print("this is the send status $status");

  if (status == SendStatus.SENT) {
    print("message sent");
  }
  if (status == SendStatus.DELIVERED) {
    print("message delivered");

    // socket.emit(
    //     "DELIVERED", Provider.of<Auth>(context, listen: false).userId);
  }
  // if (status == SendStatus) {
  //   print("message delivered");
  // }
}

void _sendsms(String phone, String message, IO.Socket socket) async {
  // print("SENDING SMS");
  try {
    bool? permissionsGranted = await telephony.requestSmsPermissions;

    print(permissionsGranted);
    print('granted status $permissionsGranted');
    if (permissionsGranted == true) {
      telephony.sendSms(
          to: phone,
          message: message,
          statusListener: (SendStatus status) {
            listener(status, socket);
          });
    }
    // print(permissionsGranted);
  } catch (e) {
    print(e);
  }
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
