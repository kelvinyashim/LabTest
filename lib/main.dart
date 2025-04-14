import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/api/patient.dart';
import 'package:test_ease/api_constants/token_role.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/cart.dart';
import 'package:test_ease/models/labs_test.dart';
import 'package:test_ease/providers/admin_test_providers.dart';
import 'package:test_ease/providers/lab_providers.dart';
import 'package:test_ease/providers/nav_index_provider.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/views/admin/admin_screen.dart';
import 'package:test_ease/views/auth_screen.dart';
import 'package:test_ease/views/labs/lab_admin_screen.dart';
import 'package:test_ease/views/onboarding/main_onboard_screen.dart';
import 'package:test_ease/views/patient/main_screen.dart';
import 'package:test_ease/views/phlebs/phleb_screen.dart';

TokenRole tokenRole = TokenRole();
var cartBox = Hive.box<CartItem>('cart');
UserApi patientApi = UserApi();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(LabsTestAdapter());
  await Hive.openBox<CartItem>('cart');
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PatientsProvider()..fetchCurrentPatient(),
        ),
        ChangeNotifierProvider(create: (context) => NavIndexProvider()),
        ChangeNotifierProvider(
          create: (context) => AdminTestProvider()..getTestCatalogue(),
        ),
        ChangeNotifierProvider(create: (context) => LabProvider()..fetchCurrentLab()),
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
      color: AppColors.greenBtn,
      debugShowCheckedModeBanner: false,
      title: 'Test Ease',
      theme: ThemeData(
        primaryColor: AppColors.greenBtn,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.greenBtn, 
        ),

        indicatorColor: AppColors.greenBtn,
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
                builder:
                    (context) => AlertDialog(
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
                return MainPatientScreen();
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
