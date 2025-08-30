import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../common/shared_class.dart';

class Codepage extends StatefulWidget {
  @override
  _CodepageState createState() => _CodepageState();
}

class _CodepageState extends State<Codepage> {
  bool showQRCode = true; // Toggle between QR Code and Barcode
  String data = ''; // Data for QR Code and Barcode
  Future<void> _loadLoyaltyNo() async {
    String? loyaltyNo = AppPreferences.prefs
        .getString('LoyaltyNo'); // Retrieve the loyalty number

    setState(() {
      data = loyaltyNo ?? '123133'; // If null, use a default value
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLoyaltyNo(); // Load loyalty number when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              width: 450,
              height: 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).hintColor.withOpacity(0.0),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  width: 2.5,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Scan to Earn 😊',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Tab for toggling QR Code and Barcode
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showQRCode = true;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              !showQRCode
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.white, // Active button color
                            ), // Set background color to white
                          ),
                          child: Text(
                            "QR Code",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .hintColor, // Set text color to hintColor from theme
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showQRCode = false;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              showQRCode
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.white, // Active button color
                            ), // Set background color to white
                          ),
                          child: Text(
                            "Bar Code",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .hintColor, // Set text color to hintColor from theme
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Barcode or QR Code Display Area
                  Text(
                    'Show Cashier to earn or redeem points',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: showQRCode
                            ? SfBarcodeGenerator(
                                value: data,
                                symbology: QRCode(),
                                showValue: false, // Hide value text below QR
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 30, 0, 30),
                                child: SfBarcodeGenerator(
                                  value: data,
                                  symbology: Code128(),
                                  showValue:
                                      true, // Show value text below barcode
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
