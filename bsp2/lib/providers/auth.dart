import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

// import 'package:pricing_calculator/models/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/http_exception.dart';
import 'package:path/path.dart';
// import 'dart:ffi';
// import 'dart:async';

import 'package:async/async.dart';
// import 'dart:convert';

// import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  // DateTime _expiryDate;
  String? _userId;
  String? _userType;
  String? _dailingcode;
  String? _fullName;
  String? _firstName;
  String? _lastName;
  String? _companyName;
  String? _companyAddress;
  String? _loginMethod;
  String? _userName;
  String? _email;
  String? _phone;
  String? _profilepic;
  int? _regStep;
  bool? _regComplete;
  // Timer _authTimer;
  final String _serverName = "https://cryptic-fjord-03848.herokuapp.com";
  // final String _serverName =
  //     Platform.isIOS ? "http://0.0.0.0:8000" : "http://10.0.2.2:8000";
  bool get isAuth {
    print(_token);
    return _token != null;
  }

  String? get companyName {
    return _companyName;
  }

  String? get companyAddress {
    return _companyAddress;
  }

  String? get _ {
    return _serverName;
  }

  String? get profilepic {
    return _profilepic;
  }

  bool? get regComplete {
    return _regComplete;
  }

  String? get dailingCode {
    return _dailingcode;
  }

  String? get email {
    return _email;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return '';
  }

  String? get userId {
    return _userId;
  }

  bool logintest(String email, String password) {
    // print(email);
    // print(password);
    return false;
  }

  void signuptest(String fullName, String email, String password) {
    print(email);
    print(password);
    print(fullName);
  }

  String? get firstname {
    return _firstName;
  }

  String? get fullName {
    return _fullName;
  }

  String? get lastname {
    return _lastName;
  }

  String? get phone {
    return _phone;
  }

  String? get username {
    return _userName;
  }

  int? get regstep {
    return _regStep;
  }

  Future<void> submitAccountSetUp(String selectedUser) async {
    // _userType;
    // print(_firstName);
    // print(_firstName);
    try {
      var url = Uri.parse('$_serverName/api/auth/final-reg-step');
      final postresponse = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": _token as String,
        },
        body: json.encode(
          {
            "email": _email,
            "location": _dailingcode,
            "firstName": _firstName,
            "lastName": _lastName,
            "userName": _userName,
            "phoneNumber": _phone
          },
        ),
      );
      if (json.decode(postresponse.body)['errors'] != null) {
        throw HttpException(json.decode(postresponse.body)['errors'][0]['msg']);
      }

      final data = json.decode(postresponse.body);
      print(data);
      if (data["success"] != true) {
        throw HttpException(
            "an unexpected error occured in creating your account");
      }
      _regComplete = true;
      _userType = selectedUser;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }

    // final prefs = await SharedPreferences.getInstance();

    // final extractedUserData =
    //     json.decode(prefs.getString('userData')) as Map<String, Object>;
    // print(extractedUserData);
    return null;
    //  _dailingcode;
    //  _firstName;
    //  _lastName;
    //  _userName;
    //  _phone;
  }

  Future<void> toFinalRegStage(Map setupdata) async {
    try {
      var url1 = Uri.parse(
          '$_serverName/api/user/unique-username?username=${setupdata['user_name']}');

      final responseData = await http.get(url1);

      print(json.decode(responseData.body));
      if (json.decode(responseData.body)['unique'] != true) {
        throw HttpException("Username is already in use");
      }

      var url2 = Uri.parse(
          '$_serverName/api/user/check-unique-phone?username=${setupdata['phone']}&location=${setupdata["dailing_code"]}');
      final responseForPhone = await http.get(url2);
      if (json.decode(responseForPhone.body)['unique'] != true) {
        throw HttpException("Phone is already connected to another account");
      }

      // return;
      _dailingcode = setupdata["dailing_code"];
      _firstName = setupdata["first_name"];
      _lastName = setupdata["last_name"];
      _userName = setupdata["user_name"];
      _phone = setupdata["phone"];
      _regStep = 3;

      notifyListeners();
      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<String?> tokenExtract() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      throw "user not authenticated";
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, String>;

    return extractedUserData["token"];
  }

  Future<dynamic> _authenticate(String email, String password, bool isSignIn,
      String? fullName, String? phone) async {
    print(email);
    print(password);
    final url = isSignIn
        ? "$_serverName/api/user/login"
        : '$_serverName/api/user/signup';

    try {
      print(url);
      final deba = json.encode(
        {
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone
          // 'returnSecureToken': true,
        },
      );
      print(deba);
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            'email': email.trim(),
            'password': password.trim(),
            'fullName': fullName?.trim(),
            'phone': phone?.trim(),

            // 'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      print(response.body);

      print("line 76");

      if (json.decode(response.body)['error'] == true) {
        throw (json.decode(response.body)['message']);
      }
      print("$_userId is the user id");

      _token = responseData['token'];
      _userId = responseData['_id'];
      print(_token);
      // if (responseData["regComplete"] == false) {
      //   print("not yet complete");
      // }

      // _regComplete = responseData["regComplete"] as bool;

      // _expiryDate = DateTime.now().add(
      //   Duration(
      //     seconds: int.parse(
      //       responseData['expiresIn'],
      //     ),
      //   ),
      // );
      // _autoLogout();

      notifyListeners();

      Workmanager().registerOneOffTask(
        "socket_worker_process",
        "socket_task",
      );

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          // 'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      return responseData;
    } catch (error) {
      // print(error);
      // print("an error");
      notifyListeners();
      throw error;
    }
  }

  Future<void> signup(
      String fullName, String email, String password, String phone) async {
    return _authenticate(email, password, false, fullName, phone);
  }

  Future<void> getIP() async {
    final url = "https://ip.nf/me.json";
    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);

    print(responseData["ip"]["country_code"]);

    final postresponse = await http.post(
      Uri.parse("$_serverName/api/auth/get_ip"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "country_code": responseData["ip"]["country_code"]
          // 'returnSecureToken': true,
        },
      ),
    );
    final dailingCodeData = json.decode(postresponse.body);
    print(dailingCodeData);
    _dailingcode = dailingCodeData['country_code'];
    // notifyListeners();
  }

  Future<void> pingserver() async {
    String url = "$_serverName/api/user/pingserver";

    try {
      final token = await gettoken();

      // print(token);
      final response =
          await http.get(Uri.parse(url), headers: {'token': token});
      final responseData = json.decode(response.body);

      // print('user gotten: ${responseData}');
    } catch (e) {
      print(e);
    }

    // final postresponse = await http.post(
    //   Uri.parse("$_serverName/api/auth/get_ip"),
    //   headers: {"Content-Type": "application/json"},
    //   body: json.encode(
    //     {
    //       "country_code": responseData["ip"]["country_code"]
    //       // 'returnSecureToken': true,
    //     },
    //   ),
    // );
    // final dailingCodeData = json.decode(postresponse.body);
    // print(dailingCodeData);
    // _dailingcode = dailingCodeData['country_code'];
    // notifyListeners();
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, true, "", "");
  }

  Future<String> gettoken() async {
    String token = "";

    try {
      final prefs = await SharedPreferences.getInstance();

      // return true;
      if (!prefs.containsKey('userData')) {
        throw "no user data";
      }
      final extractedUserData =
          json.decode(prefs.getString('userData') as String)
              as Map<String, dynamic>;

      token = extractedUserData['token'] as String;
    } catch (e) {
      print(e);
    }
    return token;
  }

  Future<bool> tryAutoLogin({bool? removeWaitTime}) async {
    final prefs = await SharedPreferences.getInstance();

    // return true;
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;

    // final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }

    print(prefs);
    print(_token);
    print(extractedUserData);
    // return true;
    try {
      final postresponse = await http.get(
        Uri.parse("$_serverName/api/user/me"),
        headers: {
          "Content-Type": "application/json",
          "token": extractedUserData['token'] as String,
        },

        // body: json.encode(
        //   {
        //     // "country_code": responseData["ip"]["country_code"]
        //     // 'returnSecureToken': true,

        //   },
        // ),
      );

      if (json.decode(postresponse.body)['message'] == "Auth Error" ||
          json.decode(postresponse.body)['message'] == "Invalid Token") {
        await Future.delayed(Duration(milliseconds: 2000));

        throw ("an Authentication Error occured");
      }

      print(371);
      print(
        json.decode(postresponse.body),
      );
      Map<String, dynamic> responseData = json.decode(postresponse.body);
      // _regComplete = responseData['regComplete'];
      _email = responseData['email'];
      _fullName = responseData["fullName"];
      _token = extractedUserData['token'] as String;
      _userId = responseData['_id'] as String;

      print('$_userId is the user id');
      // _userId = extractedUserData['userId'] as String;

      print("387");
      if (removeWaitTime == false || removeWaitTime == null) {
        await Future.delayed(Duration(milliseconds: 2000));
      }

      notifyListeners();
    } catch (e) {
      print("an error occured");
      print(e);
      throw e;
    }

    // _expiryDate = expiryDate;
    notifyListeners();
    // _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    //  _userId =;
    _userType = null;
    _dailingcode = null;
    _firstName = null;
    _lastName = null;
    _userName = null;
    _email = null;
    _phone = null;
    _regStep = null;
    _regComplete = null;
    // _expiryDate = null;
    // if (_authTimer != null) {
    //   _authTimer.cancel();
    //   _authTimer = null;
    // }
    // if (_loginMethod == "facebook") {
    //   facebookLogin.logOut();
    // }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
  bool hasAuthError(String body) {
    if (json.decode(body)['message'] == "Auth Error" ||
        json.decode(body)['message'] == "Invalid Token") {
      return true;
    }

    return false;
  }

  bool hasBadRequestError(String body) {
    if (json.decode(body)['error'] == true) {
      return true;
    }
    return false;
  }

  Future<http.Response> requestmodule(
    String method,
    String url, {
    String? token,
    String? body,
  }) async {
    http.Response postresponse;
    if (method == "get") {
      postresponse = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "token": token != null ? token : "",
        },
      );
    } else {
      // post request.
      postresponse = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "token": token != null ? token : "",
          },
          body: body);
    }

    return postresponse;
  }
}
