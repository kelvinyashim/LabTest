import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/api/patient.dart';
import 'package:test_ease/api_constants/token_role.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/patients/cart.dart';
import 'package:test_ease/models/patients/labs_test.dart';
import 'package:test_ease/providers/admin_test_providers.dart';
import 'package:test_ease/providers/cart_box_provider.dart';
import 'package:test_ease/providers/lab_providers.dart';
import 'package:test_ease/providers/nav_index_provider.dart';
import 'package:test_ease/providers/order_filter_provider.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/providers/phleb.dart';
import 'package:test_ease/providers/schedule_provider.dart';
import 'package:test_ease/providers/step_provider.dart';
import 'package:test_ease/providers/token_provider.dart';
import 'package:test_ease/views/admin/admin_screen.dart';
import 'package:test_ease/views/labs/lab_admin_screen.dart';
import 'package:test_ease/views/onboarding/main_onboard_screen.dart';
import 'package:test_ease/views/patient/main_screen.dart';

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
          create:
              (_) =>
                  PatientsProvider()
                    ..fetchCurrentPatient()
                    ..getPatientAddress()
                    ..getOrders(),
        ),
        ChangeNotifierProvider(create: (context) => NavIndexProvider()),
        ChangeNotifierProvider(
          create: (context) => AdminTestProvider()..getTestCatalogue()..getLabs(),
        ),
        ChangeNotifierProvider(
          create: (context) => LabProvider()..fetchCurrentLab(),
        ),
        ChangeNotifierProvider(create: (context) => StepProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleProvider()),
        ChangeNotifierProvider(
          create: (context) => TokenProvider()..loadRole(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartBoxProvider()..initCart(),
        ),
        ChangeNotifierProvider(create: (context) => OrderFilterProvider(),),
        ChangeNotifierProvider(create: (context) => PhlebProvider()..getPhlebs(),)
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context);
    final role = tokenProvider.tokenRole;

    Widget screens() {
      switch (role) {
        case 'Admin':
          return const AdminScreen();
        case 'User':
          return MainPatientScreen();
        case 'Lab':
          return const LabAdminScreen();
        case 'Phleb':
          return const Center();
        default:
          return MainOnboardScreen();
      }
    }

    return MaterialApp(
      color: AppColors.greenBtn,
      debugShowCheckedModeBanner: false,
      title: 'Test Ease',
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (_) => const FadeForwardsPageTransitionsBuilder(),
          ),
        ),
        primaryColor: AppColors.greenBtn,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.greenBtn,
          primary: AppColors.greenBtn,
        ),
        indicatorColor: AppColors.greenBtn,
      ),
      home:
          tokenProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : tokenProvider.tokenRole == null ||
                  tokenProvider.tokenRole!.isEmpty
              ? MainOnboardScreen()
              : screens(),
    );
  }
}
