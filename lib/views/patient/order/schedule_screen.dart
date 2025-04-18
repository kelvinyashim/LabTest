import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/providers/schedule_provider.dart';
import 'package:test_ease/providers/step_provider.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);
    final patient = Provider.of<PatientsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        toolbarHeight: 70,
        backgroundColor: AppColors.greenBtn,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        elevation: 3,
        color: AppColors.greenBtn,
        onRefresh: () async {
          await Future.delayed(Duration(microseconds: 90));
          patient.getPatientAddress();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stepper(
            connectorThickness: 2,
            physics: NeverScrollableScrollPhysics(),
            controlsBuilder: (context, ControlsDetails details) {
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: const Text('Next'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ],
              );
            },

            steps: getSteps(stepProvider, context),
            type: StepperType.horizontal,
            currentStep: stepProvider.currentstep,
            elevation: 2,
            onStepContinue: () {
              var currentStep = stepProvider.currentstep;
              final isLastStep =
                  stepProvider.currentstep ==
                  getSteps(stepProvider, context).length - 1;
              if (!isLastStep) {
                stepProvider.setNewStep(currentStep + 1);
              } else {}
            },
            onStepCancel: () {
              var current = stepProvider.currentstep;
              if (current > 0) {
                stepProvider.setNewStep(current - 1);
              }
            },
          ),
        ),
      ),
    );
  }
}

List<Step> getSteps(StepProvider step, BuildContext context) {
  final patient = Provider.of<PatientsProvider>(context, listen: false);
  final TextEditingController text_controller = TextEditingController();
  final schedule = Provider.of<ScheduleProvider>(context);
  String newAddress = "";
  return [
    Step(
      state: step.currentstep > 0 ? StepState.complete : StepState.indexed,
      title: Text("Address"),
      content:
          patient.isLoading
              ? const Center(child: CircularProgressIndicator())
              : patient.addresses.isEmpty
              ? const Center(child: Text("No Address Found"))
              : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select address",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          iconSize: 20,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  initialChildSize: 0.5,
                                  minChildSize: 0.4,
                                  maxChildSize: 0.9,
                                  builder: (_, controller) {
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(0, -3),
                                          ),
                                        ],
                                      ),
                                      child: ListView(
                                        controller: controller,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 50,
                                              height: 5,
                                              margin: EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Add New Address",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.greenBtn,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 20),
                                          TextField(
                                            controller: text_controller,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 6,
                                            onChanged: (value) {
                                              newAddress = value;
                                            },
                                            decoration: InputDecoration(
                                              label: Text(
                                                "Enter full address",
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                ),
                                              ),

                                              alignLabelWithHint: true,
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: AppColors.greenBtn,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: AppColors.greenBtn,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              patient.addAddress(newAddress);
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.greenBtn,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              "Save Address",

                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: Container(
                            alignment: Alignment.center,
                            width: 23,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.greenBtn,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "A phlebotomist will visit you at the selected address",
                      style: GoogleFonts.spectral(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: patient.addresses.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          shape: RoundedRectangleBorder(),
                          leading: Icon(Icons.home, color: AppColors.greenBtn),
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            patient.currentpatient!.name,
                            style: GoogleFonts.merriweatherSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(patient.addresses[index]),
                          trailing: Radio(
                            value: patient.addresses[index],
                            groupValue: schedule.selectedAddress,
                            onChanged: (value) {
                              schedule.selectAddress(value!);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      isActive: step.currentstep >= 0,
      stepStyle: StepStyle(
        gradient: LinearGradient(
          colors: [AppColors.greenBtn, AppColors.greenPrimaryMuted],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    Step(
      state: step.currentstep > 1 ? StepState.complete : StepState.indexed,
      title: Text("Select date"),
      isActive: step.currentstep >= 1,
      stepStyle: StepStyle(
        gradient: LinearGradient(
          colors: [AppColors.greenBtn, AppColors.greenPrimaryMuted],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      content: Column(
        children: [
          // Display the selected date or prompt user to select a date
          Text(
            "Please select a date",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
              );

              if (selectedDate != null) {
                // Set the selected date
              }
            },
            child: Text("Pick a date"),
          ),
        ],
      ),
    ),

    Step(
      state: step.currentstep > 2 ? StepState.complete : StepState.indexed,
      title: Text("Make order"),
      isActive: step.currentstep >= 2,
      stepStyle: StepStyle(
        gradient: LinearGradient(
          colors: [AppColors.greenBtn, AppColors.greenPrimaryMuted],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      content: Column(children: [

  ],),
    ),
  ];
}
