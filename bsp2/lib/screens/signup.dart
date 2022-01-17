import 'package:bsp2/screens/loading_screen.dart';
import 'package:bsp2/screens/login.dart';
import 'package:bsp2/utils/showErrorDialog.dart';
import 'package:flutter/material.dart';
import '../widgets/input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import './home.dart';

class SignUp extends StatefulWidget {
  static const id = "signup";

  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  PhoneNumber number = PhoneNumber(isoCode: 'US');

  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  bool _isLoading = false;

  FocusNode fullNameFocus = new FocusNode();
  FocusNode emailFocus = new FocusNode();
  FocusNode phoneFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  FocusNode confirmFocus = new FocusNode();

  Future<void> _signup() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).signup(
        fullNameController.text,
        emailController.text,
        passwordController.text,
        phoneController.text,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.pushNamedAndRemoveUntil(
          context, LoadingScreen.id, (route) => false);
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      showErrorDialog(e.toString(), context);
    }
    // Navigator.push(
    //   context,
    //   PageTransition(
    //     type: PageTransitionType.rotate,
    //     child: AccountCreationOne(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text("SignUp")),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            const SizedBox(height: 150),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Let's Get Started!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "FiraSans",
                  fontSize: 25,
                  letterSpacing: 0.7,
                  wordSpacing: 4,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(2.0),
              child: const Text(
                "Create your Labirynth account and start earning!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "FiraSans",
                  fontSize: 13,
                  color: Color(0xffbbbbbb),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Input(
              controller: fullNameController,
              title: "Full Name",
              obscureText: false,
              type: TextInputType.text,
              prefixIcon: Icon(
                Icons.person_outline,
                size: 18,
                color: fullNameFocus.hasFocus ? Colors.grey : Colors.grey,
              ),
              focus: fullNameFocus,
            ),
            Input(
                controller: emailController,
                type: TextInputType.emailAddress,
                obscureText: false,
                title: "Email",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: 18,
                  color: emailFocus.hasFocus ? Colors.grey : Colors.grey,
                ),
                focus: emailFocus),
            const SizedBox(height: 8),

            // Input(
            //   controller: phoneController,
            //   title: "Phone",
            //   type: TextInputType.number,
            //   prefixIcon: Icon(
            //     Icons.phone_android_outlined,
            //     size: 18,
            //     color: phoneFocus.hasFocus ? Colors.grey : Colors.grey,
            //   ),
            //   focus: phoneFocus,
            // ),
            PhoneInput(number: number, phoneController: phoneController),
            const SizedBox(height: 8),

            Input(
              controller: passwordController,
              title: "Password",
              obscureText: true,
              type: TextInputType.text,
              prefixIcon: Icon(
                Icons.password_outlined,
                size: 18,
                color: passwordFocus.hasFocus ? Colors.grey : Colors.grey,
              ),
              focus: passwordFocus,
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "By signing up you agree to the ",
                    style: TextStyle(
                      fontFamily: "FiraSans",
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, SignUp.id, (route) => false);
                    },
                    child: const Text(
                      "Terms and Conditions",
                      style: TextStyle(
                          fontFamily: "FiraSans",
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                          fontSize: 12),
                    ),
                  )
                ],
              ),
            ),

            if (!_isLoading)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 19),
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('CREATE'),
                  onPressed: () {
                    print('Pressed');

                    if (fullNameController.text.length < 5) {
                      showErrorDialog("Full Name must be filled", context);
                      return;
                    }
                    print(phoneController.text);
                    if (phoneController.text.length < 10) {
                      showErrorDialog(
                          "Please enter a valid phone number", context);
                      return;
                    }
                    if (!emailController.text.contains("@")) {
                      showErrorDialog("Email must be valid", context);
                      return;
                    }
                    if (passwordController.text.length < 8) {
                      showErrorDialog(
                          "Password must be at least 8  characters", context);
                      return;
                    }
                    _signup();
                  },
                ),
              ),

            if (_isLoading)
              Column(
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 20),
                      child: LinearProgressIndicator()),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontFamily: "FiraSans",
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Login.id, (route) => false);
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "FiraSans",
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            )
          ])),
        ),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    Key? key,
    required this.number,
    required this.phoneController,
  }) : super(key: key);

  final PhoneNumber number;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 4,
        child: InternationalPhoneNumberInput(
          spaceBetweenSelectorAndTextField: 0,
          onInputChanged: (PhoneNumber number) {
            print(number.phoneNumber);
          },
          onInputValidated: (bool value) {
            print(value);
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: Colors.black, fontSize: 10),
          initialValue: number,
          inputDecoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            // prefixIcon: Icon(Icons.phone_android),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              // borderRadius: BorderRadius.circular(25.0),
            ),
            hintText: "Phone Number",
            // labelStyle: TextStyle(
            //   fontSize: 14,
            //   fontWeight: FontWeight.w300,
            //   color: Colors.black,
            // ),
            // labelText: "Phone",
          ),
          textFieldController: phoneController,
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
            width: 7,
            color: Colors.white,
          )),
          onSaved: (PhoneNumber number) {
            print('On Saved: $number');
          },
        ),
      ),
    );
  }
}
