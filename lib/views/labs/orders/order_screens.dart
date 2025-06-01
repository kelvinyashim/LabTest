import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/api/labs/labs.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/patients/order.dart';
import 'package:test_ease/providers/phleb_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final phleb = Provider.of<PhlebProvider>(context);

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

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.greenBtn,
        title: const Text("My Orders", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('${snapshot.error ?? "No data found"}'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await labApi.acceptOrder(order.id ?? "");
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return displayModal(phleb, context, order.id ?? "", labApi);
                        },
                      ).then((_) => _refreshOrders()); // Refresh after modal closes
                    },
                    child: const Text('Accept Order'),
                  ),
                ),
              );
            },
          );
        },
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ListView.builder(
            controller: controller,
            itemCount: phleb.phlebs.length,
            itemBuilder: (context, index) {
              final fetchedPhlebs = phleb.phlebs[index];
              return ListTile(
                title: Text(fetchedPhlebs.name),
                trailing: TextButton(
                  onPressed: () async {
                    await lab.assignOrder(fetchedPhlebs.id ?? '', orderId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.greenBtn.withValues(alpha: 3),
                        content: Text(
                          'Order assigned to ${fetchedPhlebs.name}', style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  child: const Text('Assign Order'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
