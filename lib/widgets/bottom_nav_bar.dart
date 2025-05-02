import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/nav_index_provider.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavIndexProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CurvedNavigationBar(
        index: 1,
        backgroundColor: AppColors.greenBtn,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.menu),
            label: 'Orders',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle button tap
          nav.setIndex(index);
        },
      ),
    );
  }
}
