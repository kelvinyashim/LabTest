import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/patient.dart';
import 'package:test_ease/providers/patients_provider.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Patient>(
          future: Provider.of<PatientsProvider>(context, listen: false)
              .getCurrentPatient(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.greenBtn,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                        ),
                      ),
                      Text(
                        "Hello, ${patient.name}",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.notification_add,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  //  Expanded(
                  //    child: CarouselView(
                  //        scrollDirection: Axis.horizontal,
                  //        itemExtent: double.infinity,
                  //        children: List<Widget>.generate(10, (int index) {
                  //          return Center(child: Text('Item $index'));
                  //        })),
                  //  ),

                  const SizedBox(height: 20),

                  // Lab Names in Grid View
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
                      itemCount: labs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              labs[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: CurvedNavigationBar(
            index: 1,
            backgroundColor: AppColors.greenBtn,
            items: [
              CurvedNavigationBarItem(
                child: Icon(Icons.logo_dev),
                label: 'Search',
              ),
              CurvedNavigationBarItem(
                child: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              CurvedNavigationBarItem(
                child: Icon(Icons.person),
                label: 'Search',
              ),
            ],
            onTap: (index) {
              // Handle button tap
              if (index == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PatientScreen(),
                ));
              }
            },
          ),
        ));
  }
}
