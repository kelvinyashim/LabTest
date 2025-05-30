import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/views/auth_screen.dart';
import 'package:test_ease/views/patient/labs/lab_tests_screen.dart';
import 'package:test_ease/widgets/cartIcons.dart';
import 'package:test_ease/widgets/data/animations.dart';
import 'package:test_ease/widgets/data/grid_data.dart';
import 'package:test_ease/widgets/drawer.dart';
import 'package:test_ease/widgets/grid_tile.dart';

class PatientScreen extends StatelessWidget {
  PatientScreen({super.key});

  final PageController controller = PageController();

  void switchRoute(String title, context) {
    switch (title) {
      case 'Lab Test':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LabTestsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<PatientsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenBtn,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Carticons(),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () async{
             await tokenRole.logOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body:
          patient.isLoading
              ? Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                  color: AppColors.greenBtn,
                ),
              )
              : patient.currentpatient == null
              ? Center(
                child: TextButton(
                  onPressed: () => patient.fetchCurrentPatient(),
                  child: const Text(
                    'Something went wrong\nRefresh...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greenBtn,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Text(
                        "Hello, ${patient.currentpatient!.name}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: controller,
                        itemCount: promotions.length,
                        itemBuilder: (_, index) {
                          final promo = promotions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.greenBtn.withOpacity(0.85),
                                    AppColors.greenBtn,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  if (promo['image'] != null)
                                    Expanded(
                                      flex: 1,
                                      child: Lottie.asset(
                                        promo['image']!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          promo['title']!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          promo['subtitle']!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: promotions.length,
                        effect: WormEffect(
                          spacing: 8.0,
                          radius: 4.0,
                          dotWidth: 10.0,
                          dotHeight: 10.0,
                          paintStyle: PaintingStyle.stroke,
                          strokeWidth: 1.5,
                          dotColor: Colors.grey,
                          activeDotColor: AppColors.greenBtn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Services",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenBtn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.8,
                            ),
                        itemCount: gridData.length,
                        itemBuilder: (context, index) {
                          return Animate(
                            effects: [FadeEffect()],
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(33),
                              ),
                              onTap:
                                  () => switchRoute(
                                    gridData[index]['title'],
                                    context,
                                  ),
                              child: MyGridTile(
                                text: gridData[index]['title'],
                                asset: gridData[index]['asset'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
