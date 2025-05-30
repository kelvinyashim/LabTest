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
    final patient = patientProvider.currentpatient;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF5),
      body: SafeArea(
        child: patientProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.greenBtn),
              )
            : patient == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Unable to load patient data",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenBtn,
                            foregroundColor: Colors.white,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        CircleAvatar(
                          backgroundColor: AppColors.greenBtn.withOpacity(0.1),
                          radius: 60,
                          child: Icon(
                            Icons.person_rounded,
                            size: 80,
                            color: AppColors.greenBtn,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          patient.name,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          patient.email,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 30),
                        buildInfoCard(context, patientProvider),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget buildInfoCard(BuildContext context, PatientsProvider provider) {
    final patient = provider.currentpatient!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Lab_Connect",
                  applicationVersion: "1.0.0",
                  applicationIcon: const Icon(Icons.medical_information),
                );
              },
              icon: const Icon(Icons.edit_note, color: Colors.black45, size: 26),
            ),
          ),
          MyListTile(text: "Name", name: patient.name),
          const Divider(),
          MyListTile(text: "Email", name: patient.email),
          const Divider(),
          MyListTile(text: "Address", name: patient.contactInfo!.address!.first),
          const Divider(),
          MyListTile(text: "Phone", name: patient.contactInfo!.phone),
        ],
      ),
    );
  }

 
}
