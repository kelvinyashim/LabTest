import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/views/admin/grid_view.dart';
import 'package:test_ease/views/auth_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              tokenRole.logOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
            icon: Icon(Icons.abc),
          ),
        ],
        title: Text("Super Admin", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.greenDark,
      ),
      body: AdminGridView(),
    );
  }
}
