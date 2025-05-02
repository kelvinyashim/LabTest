import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/patients/order.dart';


class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: AppColors.greenBtn,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order.id}", style: titleStyle()),
            const SizedBox(height: 10),
            Text("Status: ${order.status}", style: statusStyle(order.status)),
            const SizedBox(height: 10),
            Text("Total Price: ₦${order.totalPrice}", style: subtitleStyle()),
            const SizedBox(height: 10),
            Text("Selected Address:", style: subtitleStyle()),
            Text(order.address , style: bodyStyle()),
            const SizedBox(height: 10),
            Text("Date: ${order.selectedDate.toLocal().toString().split(' ')[0]}", style: subtitleStyle()),
            Text("Time: ${order.time.format(context).toString()}", style: bodyStyle()),
            const Divider(height: 30),
            Text("Tests:", style: subtitleStyle()),
            ...order.tests.map((testItem) => ListTile(
              leading: const Icon(Icons.bloodtype, color: AppColors.greenBtn),
              title: Text(testItem.testName),
              subtitle: Text("Lab: ${testItem.labName}\n₦${testItem.price}"),
            )),
          ],
        ),
      ),
    );
  }

  TextStyle titleStyle() => GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold);
  TextStyle subtitleStyle() => GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600);
  TextStyle bodyStyle() => GoogleFonts.lato(fontSize: 14);

  TextStyle statusStyle(String? status) {
    Color color;
    switch (status) {
      case "Pending":
        color = Colors.yellow[700]!;
        break;
      case "Confirmed":
        color = Colors.teal;
        break;
      case "Assigned":
        color = Colors.green;
        break;
      case "Completed":
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: color);
  }
}
