import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/patients_provider.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenBtn,
      body: Consumer<PatientsProvider>(
        builder: (context, patientProvider, child) {
          if (patientProvider.currentpatient == null &&
              !patientProvider.isLoading) {
            // ✅ Fetch patient data if it's not already loaded
            patientProvider.fetchCurrentPatient();
          }

          return patientProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : patientProvider.currentpatient == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("No patient data available",
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              patientProvider
                                  .fetchCurrentPatient(); // Retry fetching
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          const CircleAvatar(radius: 40),
                          const SizedBox(height: 20),
                          Text(
                            "Hello, ${patientProvider.currentpatient!.name}",
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
