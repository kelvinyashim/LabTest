import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/views/patient/labs/lab_tests_screen.dart';
import 'package:test_ease/widgets/data/grid_data.dart';
import 'package:test_ease/widgets/drawer.dart';
import 'package:test_ease/widgets/grid_tile.dart';

class PatientScreen extends StatelessWidget {
  PatientScreen({super.key});

  void switchRoute(String title, context) {
    switch (title) {
      case 'Lab Test':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LabTestsScreen()));
        break;
    }
  }

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<PatientsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenBtn,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              tokenRole.logOut();
            },
            icon: Icon(Icons.abc),
          ),
        ],
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body:
          patient.isLoading
              ? Center(
                child: CircularProgressIndicator(color: AppColors.greenBtn),
              )
              : patient.currentpatient == null
              ? Center(child: Text('Something went wrong\n                    ...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),))
              : SingleChildScrollView(
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 35),
                        child: Text(
                          textAlign: TextAlign.start,
                          "Hello, ${patient.currentpatient!.name}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      width: 330,
                      child:
                          CarouselView(
                            scrollDirection: Axis.horizontal,
                            enableSplash: true,
                            itemExtent: double.infinity,
                            children: List<Widget>.generate(5, (int index) {
                              return Image.asset(
                                'lib/assets/ui/med.jpg.avif',
                                fit: BoxFit.cover,
                                color: AppColors.greenBtn,
                              );
                            }),
                          ).animate(),
                    ),
                    const SizedBox(height: 10),
                    SmoothPageIndicator(
                      controller: controller,
                      count: 5,
                      axisDirection: Axis.horizontal,
                      effect: WormEffect(
                        spacing: 8.0,
                        radius: 4.0,
                        dotWidth: 10.0,
                        dotHeight: 10.0,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 1.5,
                        dotColor: const Color.fromARGB(255, 100, 96, 96),
                        activeDotColor: AppColors.greenBtn,
                      ),
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
                          return Animate(
                            effects: [
                              ShaderEffect(duration: Animate.defaultDuration),
                            ],
                            child: InkWell(
                              splashColor: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              radius: 30,
                              onTap: () {
                                switchRoute(gridData[index]['title'], context);
                              },
                              child: MyGridTile(
                                text: gridData[index]['title'],
                                asset: gridData[index]['asset'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
