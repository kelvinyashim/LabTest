import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/order_filter_provider.dart';
import 'package:test_ease/providers/patients_provider.dart';
import 'package:test_ease/views/patient/main_screen.dart';
import 'package:test_ease/views/patient/order/order_details_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<PatientsProvider>(context);
    final orderFilter = Provider.of<OrderFilterProvider>(context);

    Color changeColor(String? status) {
      switch (status) {
        case "Pending":
          return Colors.orange;
        case "Confirmed":
          return Colors.yellow;
        case "Assigned":
          return Colors.yellowAccent;
        case "Completed":
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    final filteredOrders =
        orderFilter.showOngoing
            ? patient.orders.where((o) => o.status != "Completed").toList()
            : patient.orders.where((o) => o.status == "Completed").toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainPatientScreen()),
              );
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ],
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.greenBtn,
        centerTitle: true,
      ),
      body:
          patient.isLoading
              ? const Center(child: CircularProgressIndicator())
              : (patient.error?.isNotEmpty ?? false)
              ? Center(child: Text(patient.error!))
              : patient.orders.isEmpty
              ? const Center(child: Text("No orders placed yet."))
              : Column(
                children: [
                  const SizedBox(height: 10),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    isSelected: [
                      orderFilter.showOngoing,
                      !orderFilter.showOngoing,
                    ],
                    onPressed: (int index) {
                      orderFilter.toggle(index == 0);
                    },
                    fillColor: AppColors.greenBtn,
                    selectedColor: Colors.white,
                    color: Colors.black54,
                    constraints: const BoxConstraints(minWidth: 120),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Ongoing"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Completed"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: changeColor(order.status),
                              child: const Icon(
                                Icons.medical_services,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              "Order ID: ${order.id ?? ''}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  "Status: ${order.status ?? 'Unknown'}",
                                  style: TextStyle(
                                    color: changeColor(order.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Date: ${order.selectedDate.toLocal().toString().split(' ')[0]}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right, size: 32),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => OrderDetailsScreen(order: order),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
