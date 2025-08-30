import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_new_app/pages/widgets/transaction_card.dart';

import '../api.dart/api.dart';
import '../common/shared_class.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<dynamic> data = [];
  late List<Map<String, String>> accountData;
  List<Map<String, dynamic>> transactionDetails =
      []; // Initialized with an empty list
  bool isLoading = true; // Loading state variable

  Future<void> fetchData() async {
    try {
      String? loyaltyNo = AppPreferences.prefs.getString('LoyaltyNo');
      int? custcode = AppPreferences.prefs.getInt('cucode');

      final response = await http.post(
        Uri.parse('$api/getTodayTransactions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'LoyaltyNo': loyaltyNo, 'cucode': custcode}),
      ); // Make the GET request
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      log(responseData['result'].toString());
      if (response.statusCode == 200) {
        log(responseData['result'].toString());

        if (responseData['result'] != null &&
            responseData['result'].isNotEmpty) {
          List<Map<String, dynamic>> combinedDataList = [];

          // Loop through each result and combine 'transaction_details' and 'info'
          for (var item in responseData['result']) {
            combinedDataList.add({
              'transaction_details': item['transaction_details'],
              'info': item['info'],
            });
          }

          setState(() {
            transactionDetails =
                combinedDataList; // Set the combined list to the transactionDetails
            isLoading = false; // Stop loading spinner
          });

          log("Combined Data List: $transactionDetails");
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          topArea(context, transactionDetails),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  ) // Show loading indicator
                : displayAccoutList(
                    transactionDetails,
                  ), // Show the data once loaded
          ),
        ],
      ),
    );
  }
}
