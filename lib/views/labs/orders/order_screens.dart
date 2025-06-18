import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/api/labs/labs.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/patients/order.dart';
import 'package:test_ease/providers/phleb_provider.dart';
import 'package:test_ease/providers/order_filter_provider.dart';

class LabOrderScreen extends StatefulWidget {
  const LabOrderScreen({super.key});

  @override
  State<LabOrderScreen> createState() => _LabOrderScreenState();
}

class _LabOrderScreenState extends State<LabOrderScreen> {
  late Future<List<Order>> _ordersFuture;
  final LabApi labApi = LabApi();

  @override
  void initState() {
    super.initState();
    _ordersFuture = labApi.getOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = labApi.getOrders();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final phleb = Provider.of<PhlebProvider>(context);
    final filterProvider = Provider.of<OrderFilterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.greenBtn,
        title: const Text("My Orders", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: AppColors.greenBtn,
              color: AppColors.greenBtn,
              isSelected: [
                filterProvider.showOngoing,
                !filterProvider.showOngoing
              ],
              onPressed: (index) {
                if ((index == 0 && !filterProvider.showOngoing) ||
                    (index == 1 && filterProvider.showOngoing)) {
                  filterProvider.toggle(index == 0);
                }
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Ongoing"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Completed"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text(snapshot.error?.toString() ?? "No data found"));
                }

                final filteredOrders = snapshot.data!.where((order) {
                  final isCompleted = order.status == 'Completed';
                  return filterProvider.showOngoing ? !isCompleted : isCompleted;
                }).toList();

                if (filteredOrders.isEmpty) {
                  return const Center(child: Text("No orders to show."));
                }

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: changeColor(order.status),
                          child: const Icon(Icons.medical_services, color: Colors.white),
                        ),
                        title: Text(
                          "Order ID: ${order.id ?? ''}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        trailing: order.status != 'Completed'
                            ? ElevatedButton(
                                onPressed: () async {
                                  await labApi.acceptOrder(order.id ?? "");
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return displayModal(phleb, context, order.id ?? "", labApi);
                                    },
                                  ).then((_) => _refreshOrders());
                                },
                                child: const Text('Accept Order'),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  // Dummy action for completed order
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Result sent to patient for Order ID: ${order.id}"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text('Send Result', style: TextStyle(color: Colors.white),),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

 Widget displayModal(
  PhlebProvider phleb,
  BuildContext context,
  String orderId,
  LabApi lab,
) {
  return DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.4,
    maxChildSize: 0.9,
    builder: (_, controller) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: FutureBuilder(
          future: phleb.getPhlebs(),  // <-- call your method to fetch phlebs
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error loading phlebs: ${snapshot.error}'));
            }

            if (phleb.phlebs.isEmpty) {
              return const Center(child: Text('No phlebs available.'));
            }

            return ListView.builder(
              controller: controller,
              itemCount: phleb.phlebs.length,
              itemBuilder: (context, index) {
                final fetchedPhlebs = phleb.phlebs[index];
                return ListTile(
                  title: Text(fetchedPhlebs.name, style: const TextStyle(color: Colors.black)),
                  trailing: TextButton(
                    onPressed: () async {
                      await lab.assignOrder(fetchedPhlebs.id ?? '', orderId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.greenBtn.withAlpha(220),
                          content: Text('Order assigned to ${fetchedPhlebs.name}', style: const TextStyle(color: Colors.white)),
                        ),
                      );
                      _refreshOrders();
                    },
                    child: const Text('Assign Order'),
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}

}
