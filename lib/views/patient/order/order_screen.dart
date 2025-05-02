import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/order_filter_provider.dart';
import 'package:test_ease/providers/patients_provider.dart';
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
            return Colors.yellow;
          case "Confirmed":
            return const Color.fromARGB(255, 135, 184, 160);
          case "Assigned":
            return const Color.fromARGB(255, 101, 142, 103);
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
          title: Text('Orders'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: Text("Ongoing"),
                          selected: orderFilter.showOngoing,
                          onSelected: (_) => orderFilter.toggle(true),
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          label: Text("Completed"),
                          selected: !orderFilter.showOngoing,
                          onSelected: (_) => orderFilter.toggle(false),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: Icon(Icons.medical_services),
                              title: Text(order.id ?? ''),
                              subtitle: Text(
                                order.status ?? '',
                                style: TextStyle(
                                  color: changeColor(order.status),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailsScreen(order: order,),
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

