import 'package:flutter/material.dart';

class AdminGridItem extends StatelessWidget {
  const AdminGridItem({
    super.key,
    required this.assetImage,
    required this.text,
    required this.ontap,
  });
  final String assetImage;
  final String text;
  final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Image(
                height: 30,
                width: 30,
                image: AssetImage(assetImage),
              ),
            ),
            SizedBox(height: 15),
            Text(text),
          ],
        ),
      ),
    );
  }
}
