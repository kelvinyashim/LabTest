import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGridTile extends StatelessWidget {
  final String text;
  final String asset;
  const MyGridTile({super.key, required this.text, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(2),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, ),
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
          style: GoogleFonts.roboto(
            color: Colors.black
          ),
        ),
      ]),
    );
  }
}
