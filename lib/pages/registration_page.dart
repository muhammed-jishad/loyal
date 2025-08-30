import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_new_app/common/theme_helper.dart';
import 'package:my_new_app/pages/login_page.dart';
import 'package:my_new_app/pages/widgets/header_widget.dart';

import '../api.dart/api.dart';
import 'widgets/toast.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  int? selectedGenderIndex;
  // Controllers for form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final idNumberController = TextEditingController();
  final idTypeController = TextEditingController();

  bool checkboxValue = false;
  String? selectedGender; // To store selected gender
  String? idType; // To store selected gender

  DateTime? selectedDOB; // To store selected DOB

  // List for gender options
  List<String> genderList = ['Male', 'Female'];
  List<String> typelist = [];
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$api/formidtype'),
      ); // Make the GET request
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          typelist = responseData['response']['result']
              .map<String>((item) => item['type'].toString())
              .toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(200, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // First Name
                        SizedBox(height: 70),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: ThemeHelper().textInputDecoration(
                              'First Name',
                              'Enter your first name',
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Last Name
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: ThemeHelper().textInputDecoration(
                              'Last Name',
                              'Enter your last name',
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Mobile Number
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: mobileNumberController,
                            decoration: ThemeHelper().textInputDecoration(
                              "Mobile Number",
                              "Enter your mobile number",
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Password
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                              "Password*",
                              "Enter your password",
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 15),

                        // Gender Dropdown
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: DropdownButtonFormField<int>(
                            decoration: ThemeHelper().textInputDecoration(
                              "Gender",
                              "Pick your gender",
                            ),
                            value: selectedGenderIndex,
                            borderRadius: BorderRadius.circular(20),
                            items: genderList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final gender = entry.value;
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGenderIndex = value;
                              });
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 30),

                        // Date of Birth (DOB) Picker
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: selectedDOB != null
                                  ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(selectedDOB!)
                                  : '',
                            ),
                            decoration: ThemeHelper().textInputDecoration(
                              "Date of Birth",
                              "Select your date of birth",
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null &&
                                  pickedDate != selectedDOB)
                                setState(() {
                                  selectedDOB = pickedDate;
                                });
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: DropdownButtonFormField<String>(
                            decoration: ThemeHelper().textInputDecoration(
                              "Id Type",
                              "Pick your Id Type",
                            ),
                            value: idType,
                            borderRadius: BorderRadius.circular(20),
                            items: typelist.map((idType) {
                              return DropdownMenuItem<String>(
                                value: idType,
                                child: Text(idType),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                idType = value!;
                              });
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please select a Id';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        // ID Number
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: idNumberController,
                            decoration: ThemeHelper().textInputDecoration(
                              "ID Number",
                              "Enter your ID number",
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // ID Type
                        SizedBox(height: 20.0),

                        // Register Button
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(
                            context,
                          ),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                40,
                                10,
                                40,
                                10,
                              ),
                              child: Text(
                                _isProcessing
                                    ? "Processing..."
                                    : "Register"
                                          .toUpperCase(), // Show "Processing..." while API is being called
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing =
                                      true; // Set processing state to true
                                });

                                // API Call
                                final response = await http.post(
                                  Uri.parse('$api/register'),
                                  headers: {'Content-Type': 'application/json'},
                                  body: json.encode({
                                    "first_name": firstNameController.text,
                                    "last_name": lastNameController.text,
                                    "mobile_number":
                                        mobileNumberController.text,
                                    "password": passwordController.text,
                                    "gender": selectedGenderIndex,
                                    "dob": selectedDOB?.toIso8601String(),
                                    "id_number": idNumberController.text,
                                    "id_type": idType,
                                  }),
                                );
                                print(response.body);
                                setState(() {
                                  _isProcessing =
                                      false; // Reset processing state
                                });
                                // Handle the response
                                if (response.statusCode == 200) {
                                  final responseData = json.decode(
                                    response.body,
                                  );
                                  if (responseData["status"] == "done") {
                                    showCustomToast(
                                      context,
                                      "Registered Succesfully.",
                                    );
                                    // Navigate to LoginPage if registration is successful
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    showCustomToast(
                                      context,
                                      "Mobile number already exists.",
                                    );
                                  }
                                } else {
                                  // Show an error dialog if the request fails
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                        'Registration failed. Please try again.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),

                        // Login redirection text
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Already have an account? "),
                                TextSpan(
                                  text: 'Go to Login',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
