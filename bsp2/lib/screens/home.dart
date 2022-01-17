import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:telephony/telephony.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../widgets/specialcard.dart';
import '../models/base_pages.dart';

class Home extends StatefulWidget {
  static const id = "home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Telephony telephony = Telephony.instance;
  int _selectedIndex = 0;
  final Color _themecolor = Color(0xffffffff);

  String? _fullName = "";
  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('http://localhost:3000'),
  // );
  // var channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:3000'));

  // void _checkIfArgumentsExist() {

  //     setState(() {
  //       _selectedIndex = arguments['selected_index'];
  //     });

  //   // setState(() {
  //   //   fetchProfileData();
  //   // });
  // }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchProfileData() async {
    await Provider.of<Auth>(context, listen: false)
        .tryAutoLogin(removeWaitTime: true);

    setState(() {
      _fullName = Provider.of<Auth>(context, listen: false).fullName;
    });
  }

  @override
  void initState() {
    fetchProfileData();

    // _permission();
    // IO.Socket socket = IO.io('http://localhost:3000');
    // print(socket);
    // TODO: implement initState

    // channel.stream.listen(
    //   (data) {
    //     print(data);
    //   },
    //   onError: (error) {
    //     print(error);
    //     // print("something died");
    //   },
    //   onDone: () {
    //     print("done");
    //   },
    // );
    // initConnect();
    super.initState();
  }

  Future<bool?> _permission() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;

    return permissionsGranted;
  }

  void initConnect() {
    print("Connecting to my service");

    var socket =
        IO.io("https://terrible-chipmunk-84.loca.lt", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((data) {
      print("connect to socket");
    });

    socket.on("ping", (data) {
      // print(data);
      // print('data from server');
      if (data != null) {
        print("sendsms");
        print(data['message']);
        String message = data['message'];
        String phone = data['phone'];

        _sendsms(phone, message);
        // socket.connect();
      }
    });
  }

  void _sendsms(String phone, String message) async {
    // print("SENDING SMS");
    try {
      bool? permissionsGranted = await telephony.requestSmsPermissions;

      if (permissionsGranted == true) {
        telephony.sendSms(to: phone, message: message);
      }
      // print(permissionsGranted);
    } catch (e) {
      // print(e);
    }
  }

  @override
  void dispose() {
    // _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          backgroundColor: Colors.black,

          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          // fixedColor: Colors.black,
          // backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              // activeIcon: ,

              backgroundColor: Colors.black,
              // backgroundColor: Colors.black,
              label: "Home",
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? _themecolor : Colors.grey,
                // color: Colors.white,
              ),
              // title: Text("Home"),
            ),
            // BottomNavigationBarItem(
            //   label: "Settings",
            //   backgroundColor: Colors.black,

            //   icon: Icon(
            //     Icons.settings,
            //     color: _selectedIndex == 1 ? _themecolor : Colors.grey,
            //   ),
            //   // title: Text("Invoices"),
            // ),
            BottomNavigationBarItem(
              label: "Withdraw",
              backgroundColor: Colors.black,

              icon: Icon(
                Icons.person,
                color: _selectedIndex == 1 ? _themecolor : Colors.grey,
              ),
              // title: Text("Invoices"),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.group_add,
            //     color: _selectedIndex == 2 ? _themecolor : Colors.black,
            //   ),
            //   // title: Text("clients"),
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.settings,
            //     color: _selectedIndex == 3 ? _themecolor : Colors.black,
            //   ),
            //   // title: Text("settings"),
            // ),
            // // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.person,
            //     color: Colors.black,
            //   ),
            //   title: Text("Profile"),
            // ),
          ],

          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
