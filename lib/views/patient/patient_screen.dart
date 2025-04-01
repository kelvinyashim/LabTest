import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/patient.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/widgets/bottom_nav_bar.dart';
import 'package:test_ease/widgets/data/grid_data.dart';
import 'package:test_ease/widgets/drawer.dart';
import 'package:test_ease/widgets/grid_tile.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.greenBtn,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            )
          ],
        ),
        drawer: MyDrawer(),
        backgroundColor: Colors.white,
        body: FutureBuilder<Patient>(
          future: Provider.of<PatientsProvider>(context, listen: false)
              .getCurrentPatient(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.greenBtn,
              ));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text("No patient data available"));
            }

            final patient = snapshot.data!;
            final List<String> carouselImages = [
              'https://via.placeholder.com/400', // Replace with actual images
              'https://via.placeholder.com/400',
              'https://via.placeholder.com/400',
            ];

            final List<String> labs = [
              "MedLife Lab",
              "QuickTest Diagnostics",
              "AlphaLab",
              "CityPath Labs",
              "EcoHealth Center",
              "Prime Diagnostics"
            ];

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.greenBtn,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      ),
                    ),
                    child: Text(
                      textAlign: TextAlign.start,
                      "Hello, ${patient.name}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    width: 330,
                    child: CarouselView(
                        scrollDirection: Axis.horizontal,
                        enableSplash: true,
                        itemExtent: double.infinity,
                        children: List<Widget>.generate(5, (int index) {
                          return Container(
                            color: AppColors.greenBtn,
                          );
                        })).animate(),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2, // Adjust height
                      ),
                      itemCount: gridData.length,
                      itemBuilder: (context, index) {
                        return MyGridTile(
                            text: gridData[index]['title'],
                            asset: gridData[index]['asset']);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        );
  }
}
