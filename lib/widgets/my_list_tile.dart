import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, required this.text, required this.name});

  final String text;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: Text(text, softWrap: true, 
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.lato(
        letterSpacing: 1,
      ),),
      trailing: Text(name),
      dense: true,
      
    );
  }
}
