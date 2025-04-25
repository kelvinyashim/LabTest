import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/providers/nav_index_provider.dart';
import 'package:test_ease/views/patient/patient_screen.dart';
import 'package:test_ease/views/patient/profile_screen.dart';
import 'package:test_ease/views/patient/order/order_screen.dart';
import 'package:test_ease/widgets/bottom_nav_bar.dart';

class MainPatientScreen extends StatelessWidget {
  const MainPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavIndexProvider>(context);

    List<Widget> screens = [
      const OrderScreen(),
          PatientScreen(),
      const PatientProfileScreen()
    ];
    return Scaffold(
      body: screens[nav.selectedIndex],
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
