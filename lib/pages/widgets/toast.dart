import 'package:flutter/material.dart';

void showCustomToast(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.info_outline, color: Colors.white),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.black.withOpacity(0.7),
    duration: Duration(seconds: 3),
  );

  // Show the SnackBar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
