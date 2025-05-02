import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/models/patients/cart.dart';
import 'package:test_ease/models/patients/lab_test_order.dart';
import 'package:test_ease/models/patients/order.dart';
import 'package:test_ease/providers/cart_box_provider.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/providers/schedule_provider.dart';
import 'package:test_ease/providers/step_provider.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);
    final schedule = Provider.of<ScheduleProvider>(context);
    final patientProvider = Provider.of<PatientsProvider>(context);

    void createOrder (
      ScheduleProvider schedule,
      CartBoxProvider cartProvider,
      PatientsProvider patientProvider,
    ) {
      if (schedule.selectedAddress != null &&
          schedule.selectedDate != null &&
          schedule.selectedTime != null &&
          cartProvider.cartbox.isNotEmpty){
        int totalPrice = cartProvider.cartbox.values
            .map((e) => e.labsTest.price)
            .fold(0, (prev, curr) => prev + curr);

        final testsList =
            cartProvider.cartbox.values.map((test) {
              return LabTestItem(
                testId: test.labsTest.testId ?? '',
                testName: test.labsTest.testName,
                price: test.labsTest.price,
                labName: test.labsTest.lab,
              );
            }).toList();
        final order = Order(
          address: schedule.selectedAddress!,
          selectedDate: schedule.selectedDate!,
          time: schedule.selectedTime!,
          totalPrice: totalPrice,
          tests: testsList,
          userId: patientProvider.currentpatient!.id!,
        );

        patientProvider.createOrder(order);
        // Optionally navigate or show success message

        Future.delayed(Duration(milliseconds: 9000));

        cartBox.clear();

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Order created')));
      }
    }

    return Consumer<CartBoxProvider>(
      builder: (context, cartProvider, _) {
        if (!cartProvider.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Schedule',
              style: TextStyle(color: Colors.white),
            ),
            toolbarHeight: 70,
            backgroundColor: AppColors.greenBtn,
            elevation: 2,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.white,
          body: Stepper(
            stepIconMargin: const EdgeInsets.all(1),
            margin: const EdgeInsets.all(10),
            connectorThickness: 1,
            connectorColor: WidgetStatePropertyAll(
              AppColors.greenBtn.withValues(),
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            controlsBuilder: (context, ControlsDetails details) {
              final step = stepProvider.currentstep;
              final isLastStep =
                  step == getSteps(stepProvider, context).length - 1;
              final showNextButton = shouldShowNextButton(step, schedule);

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
                      if (step == 1 &&
                          (schedule.selectedTime == null ||
                              schedule.selectedDate == null))
                        Container()
                      else
                        ElevatedButton(
                          onPressed:
                              !isLastStep
                                  ? details.onStepContinue
                                  : () => createOrder(
                                    schedule,
                                    cartProvider,
                                    patientProvider,
                                  ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenBtn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            isLastStep ? "Finish" : "Next",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
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
              }
            },
            onStepCancel: () {
              var current = stepProvider.currentstep;
              if (current > 0) {
                stepProvider.setNewStep(current - 1);
              }
            },
          ),
        );
      },
    );
  }

  bool shouldShowNextButton(int step, ScheduleProvider schedule) {
    if (step == 0 && schedule.selectedAddress != null) {
      return true;
    }
    if (step > 0) {
      return true;
    }
    return false;
  }
}

List<Step> getSteps(StepProvider step, BuildContext context) {
  final patient = Provider.of<PatientsProvider>(context, listen: false);
  final schedule = Provider.of<ScheduleProvider>(context, listen: false);
  final orderList = Provider.of<CartBoxProvider>(context, listen: false);
  String newAddress = "";
  final TextEditingController myController = TextEditingController();
  return [
    Step(
      state: step.currentstep > 0 ? StepState.complete : StepState.indexed,
      title: FittedBox(child: Text("Address", style: TextStyle(fontSize: 13))),
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
                                            controller: myController,
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
      title: FittedBox(
        child: Text("Date and Time", style: TextStyle(fontSize: 13)),
      ),
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
                            brightness: Brightness.light,
                            surface: Colors.white,
                            primaryFixed: AppColors.greenBtn,
                            primary: AppColors.greenBtn,
                            primaryContainer: AppColors.greenBtn,
                            onTertiary: AppColors.greenBtn,
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
      title: FittedBox(
        child: Text(
          "Submit Order",
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      isActive: step.currentstep >= 2,
      stepStyle: StepStyle(
        connectorColor:
            step.currentstep == 2 ? AppColors.greenBtn : Colors.grey,
      ),
      content: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: orderList.cartbox.listenable(),
          builder: (context, Box<CartItem> box, _) {
            int totalPrice = box.values
                .map((item) => item.labsTest.price)
                .fold(0, (sum, price) => sum + price);

            if (box.isEmpty) {
              return Center(
                child: Text(
                  "No items in cart.",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Summary",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenBtn,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Address: ${schedule.selectedAddress ?? 'All'}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Date: ${schedule.formattedDate}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Time: ${schedule.formattedTime}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                Text(
                  "Order Details",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final item = box.getAt(index);
                      if (item == null) return const SizedBox.shrink();
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            item.labsTest.testName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Lab Address: ${item.labsTest.address}",
                              style: GoogleFonts.roboto(fontSize: 13.5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Total: ₦ ${totalPrice.toString()}',
                    style: GoogleFonts.poppins(
                      color: Colors.green[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  ];
}
