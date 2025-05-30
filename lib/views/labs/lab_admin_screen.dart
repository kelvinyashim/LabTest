import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/providers/lab_providers.dart';
import 'package:test_ease/views/auth_screen.dart';
import 'package:test_ease/views/labs/data/lab_admin.dart';
import 'package:test_ease/views/labs/grid_item.dart';
import 'package:test_ease/views/labs/orders/order_screens.dart';
import 'package:test_ease/views/labs/phleb.dart';

class LabAdminScreen extends StatelessWidget {
  const LabAdminScreen({super.key});

  void changeRoute(title, BuildContext context) {
    switch (title) {
      case 'Orders':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LabOrderScreen()));
         case 'Add Phleb':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AddPhlebScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lab = Provider.of<LabProvider>(context);
    return lab.isLoading
        ? Scaffold(
          body: Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white),
          ),
        )
        : Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.greenBtn,
            title: Text(lab.lab?.name ?? "Lab", style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: Icon(Icons.logout_outlined, color: Colors.white),
                onPressed: () {
                  tokenRole.logOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                  );
                },
              ),
            ],
          ),
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: labAdminData.length,
            itemBuilder: (context, index) {
              final lab = labAdminData[index];
              return LabGridItem(
                assetImage: lab['asset'],
                text: lab['title'],
                ontap: () {
                  changeRoute(lab['title'], context);
                },
              );
            },
          ),
        );
  }
}
