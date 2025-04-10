import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/models/contact_info.dart';
import 'package:test_ease/models/patient.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/views/forgot_psw.dart';
import 'package:test_ease/views/patient/main_screen.dart';
import 'package:test_ease/views/patient/patient_screen.dart';
import 'package:test_ease/widgets/custom_text.dart';
import 'package:test_ease/widgets/my_btn.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _FormsState();
}

class _FormsState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  var isLogin = true;
  var enteredName = "";
  var enteredRole = "";
  var enteredContact = "";
  var enteredAddress = "";
  var enteredEmail = "";
  var enteredPsw = "";
  bool isAuth = false;
  bool obscureText = true;

void signUp() async {
  final isValid = formKey.currentState!.validate();
  if (!isValid) return;

  formKey.currentState!.save();


  try {
      setState(() => isAuth = true);

    if (isLogin) {
      await Provider.of<PatientsProvider>(
        context,
        listen: false,
      ).loginPatient(enteredEmail, enteredPsw);


      Future.delayed(Duration(milliseconds: 10));
       Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>  PatientScreen(),
        ),
      );

      
    } else {
      await Provider.of<PatientsProvider>(
        context,
        listen: false,
      ).createPatient(
        Patient(
          name: enteredName,
          contactInfo: ContactInfo(
            address: enteredAddress,
            phone: enteredContact,
          ),
          email: enteredEmail,
          password: enteredPsw,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Account created successfully!", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>  MainPatientScreen(),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString(), style: TextStyle(color: Colors.black),),
        backgroundColor:  Colors.grey[200]
      ),
    );
  } finally {
    setState(() => isAuth = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      if (!isLogin)
                        CustomTextFormField(
                          hintText: 'Full name',
                          icon: const Icon(
                            Icons.account_circle,
                            color: Colors.black,
                          ),
                          onSaved: (newValue) => enteredName = newValue!,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 5) {
                              return "8 - 15 characters";
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 10),
                      if (!isLogin)
                        CustomTextFormField(
                          hintText: 'Contact',
                          icon: const Icon(Icons.call, color: Colors.black),
                          onSaved: (newValue) => enteredContact = newValue!,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 5) {
                              return "Must be 11 characters";
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        icon: const Icon(Icons.email, color: Colors.black),
                        hintText: "Email",
                        onSaved: (newValue) => enteredEmail = newValue!,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length < 5 ||
                              !value.contains("@")) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      if (!isLogin)
                        CustomTextFormField(
                          hintText: "Address",
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                          onSaved: (newValue) => enteredAddress = newValue!,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        icon: const Icon(Icons.lock, color: Colors.black),
                        hintText: "Password",
                        isPassword: obscureText,
                        onSaved: (newValue) => enteredPsw = newValue!,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length < 8) {
                            return "8 - 15 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      if (isLogin)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.blue.shade200,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (isAuth) const CircularProgressIndicator(),
                      if (!isAuth)
                        MyButton(
                          text: isLogin ? "Log in" : "Sign up",
                          onTap: signUp,
                        ),
                      if (!isAuth)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? "Don't have an account? Sign Up"
                                : "Already have an account? Log in",
                            style: TextStyle(
                              color: Colors.blue.shade200,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
