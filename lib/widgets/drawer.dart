import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        alignment: Alignment.center,
        color: Colors.white, // Set background color to white
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(

              decoration: BoxDecoration(
                color:
                    AppColors.greenBtn, // Keep header color different if needed
              ),
              child: CircleAvatar( backgroundColor: Colors.white, child: Icon(Icons.person, size: 100, color: Colors.grey[200],),)
              ),
            
            ListTile(
              leading: Icon(Icons.home,
                  color: Colors.black), // Ensure icons are visible
              title: Text('Home', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text('Settings', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Handle navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}
