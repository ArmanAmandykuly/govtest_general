import 'package:flutter/material.dart';

Widget menuButton(Widget img, String title, VoidCallback onPressed) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.all(12), // Button padding
      side: BorderSide(color: Colors.blue, width: 2), // Border
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
    ),
    child: SizedBox(
      height: 200,
      width: 400,
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make it compact
          children: [
            Expanded(child: img),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    ),
  );
}
