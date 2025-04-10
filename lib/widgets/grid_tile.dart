import 'package:flutter/material.dart';

class MyGridTile extends StatelessWidget {
  final String text;
  final String asset;
  const MyGridTile({super.key, required this.text, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Image(
            height: 30,
            width: 30,
            image: AssetImage(asset),
          
          ),
        ),
        SizedBox(height: 15,),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
