// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:my_new_app/pages/home_page.dart';
import 'package:my_new_app/pages/point_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api.dart/api.dart';
import '../common/shared_class.dart';
import 'Location_pages.dart';
import 'login_page.dart';
import 'show_code.dart';
import 'transaction_page.dart';
import 'widgets/drawerheader.dart';

class MyHomePage extends StatefulWidget {
  final int selectedIndex;

  const MyHomePage({super.key, required this.selectedIndex});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List of pages
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    PointPage(),
    Codepage(),
    TransactionPage(),
  ];
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    print(Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    // Request if not granted
    status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // You can prompt user to go to settings
      print(
        "Location permission permanently denied. Ask user to enable in settings.",
      );
      openAppSettings(); // Optional: bring user to app settings
    }

    return false;
  }

  Future<void> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        print('Location services are disabled.');
        return;
      }

      // Request permission
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      // Try reverse geocoding with timeout
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      print(placemarks);
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // ).timeout(
      //   Duration(seconds: 10),
      //   onTimeout: () {
      //     throw TimeoutException("Reverse geocoding timed out.");
      //   },
      // );

      Placemark place = placemarks.first;

      final locationName =
          place.locality ?? '${position.latitude}, ${position.longitude}';

      print("Location Name: $locationName");

      // Make API request
      final response = await http.post(
        Uri.parse('$api/locationsave'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "loyalty": AppPreferences.prefs.getString('LoyaltyNo'),
          "Location": locationName,
        }),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');
    } catch (e) {
      print("Error in getCurrentLocation: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                  Navigator.of(context).pop();
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
                  Navigator.push(
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
      // Use IndexedStack to manage multiple pages and preserve state
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), // Curved top-left corner
          topRight: Radius.circular(30), // Curved top-right corner
        ),
        child: Container(
          height: 90, // Adjust height to your preference
          decoration: BoxDecoration(
            color: Color.fromARGB(
              255,
              255,
              255,
              255,
            ), // Background color for the bar
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(
              255,
              255,
              255,
              255,
            ), // Transparent background to show curved effect
            selectedIconTheme: IconThemeData(
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            unselectedIconTheme: IconThemeData(
              size: 20,
              color: Theme.of(context).hintColor,
            ),
            showSelectedLabels: true,
            selectedFontSize: 11,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).hintColor,
            selectedLabelStyle: TextStyle(
              height: 2,
              color: Theme.of(context).primaryColor,
            ),
            unselectedLabelStyle: TextStyle(
              height: 2,
              color: Theme.of(context).hintColor,
            ),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Points'),
              BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Code'),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_outlined),
                label: 'History',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
