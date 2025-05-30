import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/models/patients/contact_info.dart';
import 'package:test_ease/models/patients/patient.dart';
import 'package:test_ease/providers/lab_providers.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/views/admin/admin_screen.dart';
import 'package:test_ease/views/forgot_psw.dart';
import 'package:test_ease/views/labs/lab_admin_screen.dart';
import 'package:test_ease/views/patient/main_screen.dart';
import 'package:test_ease/widgets/custom_text.dart';
import 'package:test_ease/widgets/my_btn.dart';

enum EntityType { user, lab, admin, phleb }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _FormsState();
}

class _FormsState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isAuth = false;
  bool obscureText = true;

  String enteredName = '';
  String enteredContact = '';
  String enteredAddress = '';
  String enteredEmail = '';
  String enteredPsw = '';
  EntityType? selectedEntity;

  void signUp() async {
    final patient = Provider.of<PatientsProvider>(context, listen: false);
    final lab = Provider.of<LabProvider>(context, listen: false);
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    formKey.currentState!.save();
    setState(() => isAuth = true);

    try {
      if (isLogin) {
        if (selectedEntity == EntityType.user) {
          await patient.loginPatient(enteredEmail, enteredPsw);
          await patient.fetchCurrentPatient();
          await patient.getPatientAddress();
          Navigator.of(
            context,
          ).pushReplacement(  MaterialPageRoute(builder: (_) => MainPatientScreen()),);
        } else if (selectedEntity == EntityType.lab) {
          await lab.loginLab(enteredEmail, enteredPsw);
          await lab.fetchCurrentLab();
          Navigator.of(
            context,
          
          ).pushReplacement(MaterialPageRoute(builder:(context) => LabAdminScreen(), ));
        }
        else if (selectedEntity == EntityType.admin) {
          await patient.loginPatient(enteredEmail, enteredPsw);
          Navigator.of(
            context,
          
          ).pushReplacement(MaterialPageRoute(builder:(context) => AdminScreen(), ));
        }
      } else {
        await patient.createPatient(
          Patient(
            name: enteredName,
            contactInfo: ContactInfo(
              address: [enteredAddress],
              phone: enteredContact,
            ),
            email: enteredEmail,
            password: enteredPsw,
          ),
        );
        await patient.fetchCurrentPatient();
        await patient.getPatientAddress();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Account created successfully!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainPatientScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey[300],
        ),
      );
    } finally {
      setState(() => isAuth = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.lock_open_rounded,
                      size: 72,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isLogin ? "Welcome Back" : "Create an Account",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    if (!isLogin)
                      CustomTextFormField(
                        hintText: 'Full name',
                        icon: const Icon(Icons.account_circle),
                        onSaved: (val) => enteredName = val!,
                        validator:
                            (val) =>
                                val == null || val.length < 3
                                    ? "Enter valid name"
                                    : null,
                      ),
                    if (!isLogin) const SizedBox(height: 10),
                    if (!isLogin)
                      CustomTextFormField(
                        hintText: 'Contact',
                        icon: const Icon(Icons.phone),
                        onSaved: (val) => enteredContact = val!,
                        validator:
                            (val) =>
                                val == null || val.length < 8
                                    ? "Enter valid contact"
                                    : null,
                      ),
                    if (!isLogin) const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Email',
                      icon: const Icon(Icons.email),
                      onSaved: (val) => enteredEmail = val!,
                      validator:
                          (val) =>
                              val != null && val.contains("@")
                                  ? null
                                  : "Enter valid email",
                    ),
                    const SizedBox(height: 10),
                    if (!isLogin)
                      CustomTextFormField(
                        hintText: 'Address',
                        icon: const Icon(Icons.location_on),
                        onSaved: (val) => enteredAddress = val!,
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? "Enter address"
                                    : null,
                      ),
                    if (!isLogin) const SizedBox(height: 10),

                    CustomTextFormField(
                      hintText: "Password",
                      icon: const Icon(Icons.lock, color: Colors.black),
                      isPassword: true,
                      obscureText: obscureText,
                      togglePasswordVisibility: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      onSaved: (value) => enteredPsw = value!,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),
                    if (isLogin)
                      DropdownButtonFormField<EntityType>(
                        value: selectedEntity,
                        hint: const Text('Login as'),
                        items: const [
                          DropdownMenuItem(
                            value: EntityType.user,
                            child: Text('User'),
                          ),
                          DropdownMenuItem(
                            value: EntityType.lab,
                            child: Text('Lab'),
                          ),
                           DropdownMenuItem(
                            value: EntityType.admin,
                            child: Text('Admin'),
                          ),
                           DropdownMenuItem(
                            value: EntityType.phleb,
                            child: Text('Phleb'),
                          ),
                        ],
                        onChanged:
                            (val) => setState(() => selectedEntity = val),
                        validator: (val) => val == null ? "Select role" : null,
                      ),
                    if (isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              ),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blue.shade300),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    isAuth
                        ? const CircularProgressIndicator()
                        : MyButton(
                          text: isLogin ? "Log In" : "Sign Up",
                          onTap: signUp,
                        ),
                    TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Log In",
                        style: TextStyle(color: Colors.blue.shade300),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
