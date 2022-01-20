import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:telephony/telephony.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../widgets/specialcard.dart';
import 'dart:math';
import 'dart:async';

class Dashboard extends StatefulWidget {
  static const id = "home";

  @override
  State<Dashboard> createState() => _HomeState();
}

class _HomeState extends State<Dashboard> {
  final Telephony telephony = Telephony.instance;
  int _selectedIndex = 0;
  String? _fullName = "";
  String? _userID = "";

  var _socket;
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

    Timer timer;

    timer = Timer.periodic(
        const Duration(seconds: 60), (Timer t) => logonlinetime());
    setState(() {
      _fullName = Provider.of<Auth>(context, listen: false).fullName;
      _userID = Provider.of<Auth>(context, listen: false).userId;
    });

    print('$_userID is the user id from 61 dashboard');
  }

  Future<void> logonlinetime() async {
    print("running every 60 seconds");
    await Provider.of<Auth>(context, listen: false).pingserver();
  }

  @override
  void initState() {
    fetchProfileData();

    _permission();
    // initConnect();
    super.initState();
  }

  Future<bool?> _permission() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;

    return permissionsGranted;
  }

  void initConnect() {
    print("Connecting to my service");

    var socket = IO.io("wss://homesimb.powersms.land/", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      "query": "userid=${Provider.of<Auth>(context, listen: false).userId}"
    });

    socket.connect();
    socket.onConnect((data) async {
      print("connected to socket");
      await Provider.of<Auth>(context, listen: false).pingserver();
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
  }

  void listener(SendStatus status, IO.Socket socket) {
    // Handle the status
    print("this is the send status $status");

    if (status == SendStatus.SENT) {
      print("message sent");
    }
    if (status == SendStatus.DELIVERED) {
      print("message delivered");

      socket.emit(
          "DELIVERED", Provider.of<Auth>(context, listen: false).userId);
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

  @override
  void dispose() {
    // _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 220,
                    padding: EdgeInsets.all(20),
                    color: Color.fromARGB(255, 0, 12, 29),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Welcome, ${_fullName?.split(" ")[0]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "FiraSans",
                                  )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Status:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "FiraSans",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Text(
                                    "Active",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "FiraSans",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(.4),
                                            spreadRadius: 3,
                                            blurRadius: 3,
                                            offset: const Offset(1, 1),
                                          )
                                        ]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ]),
                  ),
                ),
                Positioned(
                    right: 0,
                    left: 0,
                    bottom: -52,
                    child: Center(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.4),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.blue,
                        ),
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("My Balance",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "FiraSans",
                                  )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("\$",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                    "0.00",
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "FiraSans",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 70,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Account Details",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "FiraSans",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
              // width: 80,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  RoundedCard(
                    color: Colors.orange,
                    title: "Earnings (\$)",
                    subtitle: "All Time",
                    price: "0.00",
                  ),
                  RoundedCard(
                      color: const Color.fromARGB(255, 230, 73, 125),
                      title: "Earnings (\$)",
                      subtitle: "This Month",
                      price: "0.00"),
                  RoundedCard(
                      color: Colors.indigo,
                      title: "Uptime",
                      subtitle: "All time (minutes)",
                      price: "1"),
                  RoundedCard(
                      color: Colors.purple,
                      title: "Uptime",
                      subtitle: "This month",
                      price: "1"),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
              // width: 80,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  onPressed: () {}, child: Text("Withdraw My Earnings")),
            ),
            const SizedBox(
              height: 30,
              // width: 80,
            ),
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.symmetric(horizontal: 30),
            //   child:
            //       ElevatedButton(onPressed: () {}, child: Text("Set Wallet")),
            // )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RoundedCard extends StatelessWidget {
  Color color;
  String price;
  String subtitle;
  String title;
  RoundedCard(
      {Key? key,
      @required required this.color,
      @required required this.price,
      @required required this.subtitle,
      @required required this.title})
      : super(key: key);
// Random rand = new Random();

  @override
  Widget build(BuildContext context) {
    double randomNumber = Random().nextInt(5) + 10;
    return Container(
      // height: 130,
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
          // topRight: Radius.circular(10),
          // bottomLeft: Radius.circular(10),
          // bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.5),
            spreadRadius: 2,
            blurRadius: 5,
            // blurStyle: BlurStyle.,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "FiraSans",
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "FiraSans",
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 3,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              )),
        ),
        const SizedBox(
          height: 3,
        ),
        Container(
          height: 3,
          margin: EdgeInsets.only(right: randomNumber),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(14),
              )),
        ),
        const SizedBox(
          height: 30,
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Text(price,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "FiraSans",
              )),
        ),
      ]),
    );
  }
}
