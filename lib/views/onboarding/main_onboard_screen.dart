import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/views/auth_screen.dart';
import 'package:test_ease/views/onboarding/first.dart';
import 'package:test_ease/views/onboarding/second.dart' show SecondOnboardingScreen;
import 'package:test_ease/views/onboarding/third.dart';



class MainOnboardScreen extends StatelessWidget {
  MainOnboardScreen({super.key});

  final PageController controller = PageController();
  AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = const [
      OnboardingScreen(),
      SecondOnboardingScreen(),
      ThirdOnboardingScreen()
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: screens,
          ),
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                axisDirection: Axis.horizontal,
                effect:  SlideEffect(
                  spacing: 8.0,
                  radius: 4.0,
                  dotWidth: 10.0,
                  dotHeight: 10.0,
                  paintStyle: PaintingStyle.stroke,
                  strokeWidth: 1.5,
                  dotColor: const Color.fromARGB(255, 100, 96, 96),
                  activeDotColor:AppColors.greenBtn,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.greenBtn,
                      borderRadius: BorderRadiusDirectional.circular(30)),
                  width: double.infinity,
                  height: 50,
                  child: Text(
                    "Get started",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
