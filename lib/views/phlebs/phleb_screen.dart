import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/phleb_provider.dart';
import 'package:test_ease/providers/order_filter_provider.dart';
import 'package:test_ease/views/auth_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PhlebScreen extends StatelessWidget {
  const PhlebScreen({super.key});

  void _openInMaps(String address, BuildContext context) async {
    final query = Uri.encodeComponent(address);
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.grey,
          content: Text('Could not launch map'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final phlebProvider = Provider.of<PhlebProvider>(context);
    final orderFilter = Provider.of<OrderFilterProvider>(context);
    final ongoingStatuses = ['Pending', 'Accepted', 'Assigned'];

    final filteredOrders =
        orderFilter.showOngoing
            ? phlebProvider.orders
                .where((o) => ongoingStatuses.contains(o.status))
                .toList()
            : phlebProvider.orders
                .where((o) => o.status == "Completed")
                .toList();

    for (var order in phlebProvider.orders) {
      print('Order status: "${order.status}"');
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.greenBtn,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body:
          phlebProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
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
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(order.selectedAddress),
                                const SizedBox(height: 6),
                                Text(
                                  '₦${order.totalPrice}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  order.tests.first.testName,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed:
                                          () => _openInMaps(
                                            order.selectedAddress,
                                            context,
                                          ),
                                      icon: const Icon(
                                        Icons.map,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "Open in Maps",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal[600],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed:
                                          order.status == 'Completed'
                                              ? null
                                              : () async {
                                                if (order.status ==
                                                    'Assigned') {
                                                  await phlebProvider
                                                      .acceptOrder(order.id!);
                                                } else if (order.status ==
                                                    'Accepted') {
                                                  await phlebProvider
                                                      .markComplete(order.id!);
                                                }
                                                await phlebProvider.getOrders();
                                              },
                                      icon: Icon(
                                        order.status == 'Assigned'
                                            ? Icons.check
                                            : order.status == 'Accepted'
                                            ? Icons.check_circle
                                            : Icons.done_all,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        order.status == 'Assigned'
                                            ? "Accept"
                                            : order.status == 'Accepted'
                                            ? "Mark Complete"
                                            : "Completed",

                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            order.status == 'Completed'
                                                ? Colors.grey
                                                : AppColors.greenBtn,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
