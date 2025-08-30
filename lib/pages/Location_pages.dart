import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_new_app/pages/main_page.dart';
import 'package:my_new_app/pages/widgets/drawerheader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api.dart/api.dart';
// import '../common/shared_class.dart';
import '../common/shared_class.dart';
import 'login_page.dart';

class loaction extends StatefulWidget {
  const loaction({super.key});

  @override
  State<loaction> createState() => _loactionState();
}

class _loactionState extends State<loaction> {
  double _drawerFontSize = 17;
  double _drawerIconSize = 24;
  var branchList;
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$api/branchesall'));
      print(response.body); // Make the GET request
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          // Map the 'result' and extract the required values
          branchList = responseData['response']['result'];
          // print(branchList);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).hintColor,
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).hintColor.withOpacity(0.2),
              ],
            ),
          ),
          child: ListView(
            children: [
              CustomDrawerHeader(),
              ListTile(
                leading: Icon(
                  Icons.home_outlined,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(selectedIndex: 0),
                    ),
                    (route) => false, // Remove all routes
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.location_on_outlined,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Store Locations',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => loaction()),
                  );
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.settings,
              //       size: _drawerIconSize, color: Theme.of(context).hintColor),
              //   title: Text(
              //     'Settings',
              //     style: TextStyle(
              //         fontSize: _drawerFontSize,
              //         color: Theme.of(context).hintColor),
              //   ),
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (context) => RegistrationPage()),
              //     // );
              //   },
              // ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                onTap: () async {
                  await AppPreferences.clear();

                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false, // Remove all routes
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      body: branchList == null
          ? Center(
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 2.0,
                color: Theme.of(context).primaryColor,
              ),
            )
          : Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        branchList.length, // Number of items in branchList
                    itemBuilder: (context, index) {
                      final branch =
                          branchList[index]; // Get branch data at index
                      return ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              10.0,
                              10,
                              10,
                              10,
                            ),
                            child: Container(
                              width:
                                  double.infinity, // Set width to match screen
                              height: 210,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                                    Theme.of(
                                      context,
                                    ).hintColor.withOpacity(0.1),
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp,
                                ),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.8),
                                  width: 2.5,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  25,
                                  20,
                                  25,
                                  0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          branch['BranchDesc'] ?? "Branch Name",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        Icon(
                                          Icons.shopping_cart, // Trolley Icon
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          branch['Address'] ?? "Branch Address",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          branch['mobile'] ?? "Branch Mobile",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    // Email
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          branch['email'] ?? "Branch Email",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Open Instagram link
                                            _launchURL(branch['instagram']);
                                          },
                                          child: Image.asset(
                                            'assets/in.png', // Path to your Instagram icon asset
                                            width: 24, // Icon size
                                            height: 24, // Icon size
                                            color: Theme.of(
                                              context,
                                            ).primaryColor, // Optional: to change color of the icon
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Open Facebook link
                                            _launchURL(branch['facebook']);
                                          },
                                          child: Image.asset(
                                            'assets/fb.png', // Path to your Facebook icon asset
                                            width: 24, // Icon size
                                            height: 24, // Icon size
                                            color: Theme.of(
                                              context,
                                            ).primaryColor, // Optional: to change color of the icon
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
