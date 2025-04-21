import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/api/patient.dart';
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
    final schedule = Provider.of<ScheduleProvider>(context);
    UserApi userApi = UserApi();

   

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule', style: TextStyle(color: Colors.white)),
        toolbarHeight: 70,
        backgroundColor: AppColors.greenBtn,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Stepper(
        stepIconMargin: EdgeInsets.all(1),
        margin: EdgeInsets.all(10),
        connectorThickness: 1,
        connectorColor: WidgetStatePropertyAll(AppColors.greenBtn.withValues()),
        physics: AlwaysScrollableScrollPhysics(),
        controlsBuilder: (context, ControlsDetails details) {
          final step = stepProvider.currentstep;
          final isAddressSelected = schedule.selectedAddress != null;
          final isLastStep = step == getSteps(stepProvider, context).length - 1;

          bool showNextButton = false;
          if (step == 0 && isAddressSelected) {
            showNextButton = true;
          } else if (step > 0) {
            showNextButton = true;
          }

          return SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (step > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),

                if (showNextButton)
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenBtn,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isLastStep ? "Finish" : "Next",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
              ],
            ),
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
    );
  }
}

List<Step> getSteps(StepProvider step, BuildContext context) {
  final patient = Provider.of<PatientsProvider>(context, listen: false);
  final TextEditingController text_controller = TextEditingController();
  final schedule = Provider.of<ScheduleProvider>(context, listen: false);
  String newAddress = "";
  return [
    Step(
      state: step.currentstep > 0 ? StepState.complete : StepState.indexed,
      title: FittedBox(child: Text("Address", style: TextStyle(fontSize: 13),)),
      content:
          patient.isLoading
              ? const Center(child: CupertinoActivityIndicator(radius: 12))
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
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
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
                            leading: Icon(
                              Icons.home,
                              color: AppColors.greenBtn,
                            ),
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
                  ),
                ],
              ),
      isActive: step.currentstep >= 0,
      
    ),
    Step(
      state: step.currentstep > 1 ? StepState.complete : StepState.indexed,
      title: FittedBox(child: Text("Date and Time", style: TextStyle(fontSize: 13),)),
      isActive: step.currentstep >= 1,
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please select a date and time",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            Consumer<ScheduleProvider>(
              builder: (context, schedule, child) {
                final date = schedule.selectedDate;
                final time = schedule.selectedTime;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date != null
                          ? "Date: ${date.toLocal().toString().split(' ')[0]}"
                          : "No date selected yet",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            date != null
                                ? Colors.black87
                                : const Color.fromARGB(255, 138, 61, 61),
                      ),
                    ),
                    if (time != null) ...[
                      SizedBox(height: 5),
                      Text(
                        "Time: ${time.format(context)}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ],
                );
              },
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.greenBtn,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                            secondary: AppColors.greenBtn,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.greenBtn,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (selectedDate != null) {
                    Provider.of<ScheduleProvider>(
                      context,
                      listen: false,
                    ).selectDate(selectedDate);

                    // Time picker after date is picked
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              backgroundColor: Colors.grey[200],
                              hourMinuteColor: AppColors.greenBtn.withOpacity(
                                0.1,
                              ),
                              hourMinuteTextColor: AppColors.greenBtn,
                              dayPeriodColor:
                                  AppColors.greenBtn, // AM/PM background
                              dayPeriodTextColor:
                                  Colors.white, // AM/PM text color
                              dialHandColor: Colors.white,
                              dialBackgroundColor: AppColors.greenBtn,
                              dialTextColor:
                                  Colors.black, // Numbers on the clock
                              entryModeIconColor: AppColors.greenBtn,
                            ),
                            colorScheme: ColorScheme.light(
                              primary: AppColors.greenBtn,
                              onPrimary: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (selectedTime != null) {
                      Provider.of<ScheduleProvider>(
                        context,
                        listen: false,
                      ).selectTime(selectedTime);
                    }
                  }
                },
                icon: Icon(Icons.calendar_today, color: Colors.white),
                label: Text(
                  "Pick Date & Time",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenBtn,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    ),

    Step(
      state: step.currentstep > 2 ? StepState.complete : StepState.indexed,
      title: FittedBox(child: Text("Submit order",style: TextStyle(fontSize: 13),)),
      isActive: step.currentstep >= 2,
      stepStyle: StepStyle( connectorColor: step.currentstep > 2
            ? AppColors.greenBtn
            : Colors.grey,),
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(children: [Text('Hello')]),
      ),
    ),
  ];
}
