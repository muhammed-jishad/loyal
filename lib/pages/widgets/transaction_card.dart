import 'dart:ui';

import 'package:flutter/material.dart';

Container accountItems(String item, String discharge, String incharge,
        String dateString, String type,
        {Color oddColour = Colors.white}) =>
    Container(
      decoration: BoxDecoration(color: oddColour),
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item, style: TextStyle(fontSize: 16.0)),
              Text(incharge == 0 ? discharge : incharge,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: incharge == 0 ? Colors.red : Colors.green,
                  ))
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(type, style: TextStyle(color: Colors.grey, fontSize: 14.0)),
              Text(dateString,
                  style: TextStyle(color: Colors.grey, fontSize: 14.0))
            ],
          ),
        ],
      ),
    );

ClipRRect topArea(
    BuildContext context, List<Map<String, dynamic>> transactionDetails) {
  // Assuming the first item has the 'transaction_date' and 'loyality_point' to display
  var transaction =
      transactionDetails.isNotEmpty ? transactionDetails[0] : null;
  var transactionDate =
      transaction != null ? transaction['info']['transaction_date'] : '';
  var loyaltyPoint =
      transaction != null ? transaction['info']['loyality_point'] : 0;

  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(25)),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
        child: Container(
          width: 450,
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.4),
                Theme.of(context).hintColor.withOpacity(0.4),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
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
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  transactionDate, // Displaying the transaction date
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .hintColor, // Accent color for transaction date
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Loyalty Points ", // Displaying the transaction date
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .hintColor, // Accent color for transaction date
                  ),
                ),
                Text(
                  '$loyaltyPoint', // Displaying the transaction date
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .hintColor, // Accent color for transaction date
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

Widget displayAccoutList(List<Map<String, dynamic>> transactionDetails) {
  print(transactionDetails); // Prints the entire list for debugging

  return Container(
    margin: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
    child: ListView.builder(
      itemCount: transactionDetails.length, // Get the number of items
      itemBuilder: (context, index) {
        // Access each transaction item from the list
        final transaction = transactionDetails[index];
        final transactionDetailsItem = transaction['transaction_details'];
        final info = transaction['info'];
        print(transactionDetailsItem);

        // Return a ListTile for each item with relevant details
        return ListTile(
          // title: Text("Bill No: ${transactionDetailsItem['BillNo']}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${transactionDetailsItem['BranchDesc']}",
                            style: TextStyle(fontSize: 16.0)),
                        Text(
                          double.parse(transactionDetailsItem['Addition']
                                      .toString()) ==
                                  0
                              ? "-${transactionDetailsItem['Deduction']}" // Show Deduction with "-"
                              : "+${transactionDetailsItem['Addition']}", // Show Addition with "+"
                          style: TextStyle(
                            fontSize: 16.0,
                            color: double.parse(
                                        transactionDetailsItem['Addition']
                                            .toString()) ==
                                    0
                                ? Colors.red // Red for Deduction
                                : Colors.green, // Green for Addition
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${transactionDetailsItem['BillAmount']}",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                        Text("${info['transaction_date']}",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0))
                      ],
                    ),
                  ],
                ),
              )

              // Text("Amount: ${transactionDetailsItem['BillAmount']}"),
            ],
          ),
        );
      },
    ),
  );
}
