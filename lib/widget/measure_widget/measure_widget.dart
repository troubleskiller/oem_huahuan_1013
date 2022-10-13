
import 'package:flutter/material.dart';

class MeasureCommonWidget extends StatelessWidget {
  final String title;
  final String detail;
  const MeasureCommonWidget({Key? key, required this.title, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      height: 50,
      width: 120,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 10,
              color: Colors.white,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            detail,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 10,
              color: Colors.white,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
