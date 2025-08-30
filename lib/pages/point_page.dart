import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api.dart/api.dart';
import '../common/shared_class.dart';
import 'main_page.dart';

class PointPage extends StatefulWidget {
  @override
  _PointPageState createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  double? netPoints;
  String? date;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPointData();
  }

  Future<void> fetchPointData() async {
    String? loyaltyNo = AppPreferences.prefs.getString('LoyaltyNo');
    int? custcode = AppPreferences.prefs.getInt('cucode');

    final response = await http.post(
      Uri.parse('$api/getMyPoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'LoyaltyNo': loyaltyNo, "cucode": custcode}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        netPoints = double.tryParse(data['net_points'].toString());
        date = data['date'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 450,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.4),
                          Theme.of(context).hintColor.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                      ),
                      border: Border.all(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.8), // Primary color for the border
                        width: 2.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Point',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      wordSpacing: 3,
                                    ),
                                  ),
                                  Text(
                                    '${netPoints?.toStringAsFixed(2) ?? "0.00"}',
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'As on ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  wordSpacing: 3,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' ${date ?? "--"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(
                            height: 5,
                            thickness: 2,
                            color: Theme.of(context).hintColor,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                        selectedIndex: 2,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.qr_code,
                                      size: 50,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Text(
                                      'My ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                        selectedIndex: 3,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.text_snippet_outlined,
                                      size: 50,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Text(
                                      'My History',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
