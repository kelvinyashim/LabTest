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

    // Trigger fetchCurrentPatient if data isn't available yet

    return Scaffold(
        backgroundColor: AppColors.greenBtn,
        body: patientProvider.isLoading
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
                          onPressed: () {
                            patientProvider.fetchCurrentPatient(); // Retry
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 60,
                              child: Icon(
                                Icons.person_rounded,
                                size: 90,
                                color: Colors.grey[300],
                              ),
                            ),
                            SizedBox(height: 15),
                         
                            Container(
                                alignment: Alignment.topRight,
                                width: double.infinity,
                                height: 330,
                                margin: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                 mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                   IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit_note,
                                color: Colors.grey,
                                size:35,
                              ),
                              alignment: Alignment.topRight,
                              
                            ),
                            MyListTile(text: "Name", name: patientProvider.currentpatient!.name),
                            MyListTile(text: "Email", name: patientProvider.currentpatient!.email),
                            MyListTile(text: "Address", name: patientProvider.currentpatient!.contactInfo!.address!),
                            MyListTile(text: "Phone", name: patientProvider.currentpatient!.contactInfo!.phone),
                            
                            
                                ])),

                                 Container(
                                alignment: Alignment.topRight,
                                width: double.infinity,
                                height: 330,
                                margin: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child:Text("he"))
                          ],
                        ),
                      ),
                    ),
                ));
  }
}
