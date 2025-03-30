import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/api_constants/token_role.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/views/admin/admin_screen.dart';
import 'package:test_ease/views/auth_screen.dart';
import 'package:test_ease/views/labs/lab_admin_screen.dart';
import 'package:test_ease/views/onboarding/main_onboard_screen.dart';
import 'package:test_ease/views/patient/patient_screen.dart';
import 'package:test_ease/views/phlebs/phleb_screen.dart';

TokenRole tokenRole = TokenRole();

void main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientsProvider()),
      ],
      child: MyApp(),
    ),
  
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Ease',
      theme: ThemeData(
        primaryColor: AppColors.greenBtn,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.greenBtn,
        ),
      ),
      home: FutureBuilder(
        future: tokenRole.getTokenRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

         
          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text(snapshot.error.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            });
            return AuthScreen(); 
          }


          if (snapshot.hasData || snapshot.data != null) {
            final role = snapshot.data;

            switch (role) {
              case 'Admin':
                return AdminScreen();
              case 'User':
                return PatientScreen();
              case 'Lab':
                return LabAdminScreen();
              case 'Phleb':
                return PhlebScreen();
              default:
                return AuthScreen();
            }
          } else {
            return MainOnboardScreen();
          }
        },
      ),
    );
  }
}
