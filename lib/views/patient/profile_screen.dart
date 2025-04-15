import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/widgets/my_list_tile.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:
          patientProvider.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : patientProvider.currentpatient == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Failed to load patient data",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.greenBtn,
                      ),
                      onPressed: () {
                        patientProvider.fetchCurrentPatient();
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: Icon(
                        Icons.person_rounded,
                        size: 90,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      patientProvider.currentpatient!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Info Card
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                showAboutDialog(context: context, applicationName: "Lab_Connect", applicationVersion: "1.0.0", applicationIcon: Icon(Icons.medical_information), );
                              },
                              icon: const Icon(
                                Icons.edit_note,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          MyListTile(
                            text: "Name",
                            name: patientProvider.currentpatient!.name,
                          ),
                          MyListTile(
                            text: "Email",
                            name: patientProvider.currentpatient!.email,
                          ),
                          MyListTile(
                            text: "Address",
                            name:
                                patientProvider
                                    .currentpatient!
                                    .contactInfo!
                                    .address!.first,
                          ),
                          MyListTile(
                            text: "Phone",
                            name:
                                patientProvider
                                    .currentpatient!
                                    .contactInfo!
                                    .phone,
                          ),
                        ],
                      ),
                    ),

                    // Placeholder for another section
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Additional Information (Coming Soon)",
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
    );
  }
}
