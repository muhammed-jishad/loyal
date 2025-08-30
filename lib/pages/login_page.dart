import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api.dart/api.dart';
import '../common/shared_class.dart';
import '../common/theme_helper.dart';
import 'main_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';
import 'widgets/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Define the base URL
  final String loginEndpoint =
      "/login"; // Replace with your actual login endpoint

  Future<void> _login() async {
    final String apiUrl = "$api$loginEndpoint";

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showCustomToast(context, "Please enter both username and password.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = response.body; // Raw response body
        final jsonResponse = json.decode(responseData);

        if (jsonResponse['status'] == 'done') {
          final loyaltyNo = jsonResponse['customer']['LoyaltyNo'];
          final custName = jsonResponse['customer']['name'];
          final CustomerCode = jsonResponse['customer']['CustomerCode'];

          // Save LoyaltyNo to shared preferences
          await AppPreferences.setLoyalty(loyaltyNo);
          await AppPreferences.setName(custName);
          await AppPreferences.setCustomerCode(CustomerCode);

          // Navigate to MyHomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      selectedIndex: 0,
                    )),
          );
        } else {
          final errorMessage = jsonResponse['msg'] ?? "An error occurred.";
          showCustomToast(context, errorMessage);
        }
      } else {
        showCustomToast(
            context, "Failed to connect to server. Please try again.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              child: HeaderWidget(250, true, Icons.login_rounded),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextField(
                        controller: _usernameController,
                        decoration: ThemeHelper().textInputDecoration(
                            "Mobile Number", "Loyality/Mobile Number"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: ThemeHelper()
                            .textInputDecoration("Password", "password"),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: _login,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      //child: Text('Don\'t have an account? Create'),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "Don\'t have an account? "),
                        TextSpan(
                          text: 'Create',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPage()));
                            },
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor),
                        ),
                      ])),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
