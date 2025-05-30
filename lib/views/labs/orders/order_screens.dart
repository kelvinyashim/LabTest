import 'package:flutter/material.dart';
import 'package:test_ease/api/labs/labs.dart';
import 'package:test_ease/constants/color.dart';

class LabOrderScreen extends StatelessWidget {
  const LabOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    final LabApi labApi = LabApi();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.greenBtn,
        title: Text("My Orders", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder(
        future: labApi.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 10,
                  ),
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await labApi.acceptOrder(order.id ?? "");
                        Future.microtask(()async{
                          await labApi.getOrders();
                        });
                        

                        // showModalBottomSheet(
                        //       context: context,
                        //       isScrollControlled: true,
                        //       backgroundColor: Colors.transparent,
                        //       builder: (context) {
                        //         return DraggableScrollableSheet(
                        //           initialChildSize: 0.5,
                        //           minChildSize: 0.4,
                        //           maxChildSize: 0.9,
                        //           builder: (_, controller) {
                        //             return Container(
                        //               padding: const EdgeInsets.all(15),
                        //               decoration: BoxDecoration(
                        //                 color: Colors.white,
                        //                 borderRadius: BorderRadius.only(
                        //                   topLeft: Radius.circular(30),
                        //                   topRight: Radius.circular(30),
                        //                 ),
                        //                 boxShadow: [
                        //                   BoxShadow(
                        //                     color: Colors.black26,
                        //                     blurRadius: 10,
                        //                     offset: Offset(0, -3),
                        //                   ),
                        //                 ],
                        //               ),
                        //               child: ListView(
                        //                 controller: controller,
                        //                 children: [
                        //                   Center(
                        //                     child: Container(
                        //                       width: 50,
                        //                       height: 5,
                        //                       margin: EdgeInsets.only(
                        //                         bottom: 20,
                        //                       ),
                        //                       decoration: BoxDecoration(
                        //                         color: Colors.grey[300],
                        //                         borderRadius:
                        //                             BorderRadius.circular(10),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   Text(
                        //                     "Phlebotomists",
                        //                     style: TextStyle(
                        //                       fontSize: 20,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: AppColors.greenBtn,
                        //                     ),
                        //                     textAlign: TextAlign.center,
                        //                   ),
                        //                 ],
                        //               ),
                        //             );
                        //           },
                        //         );
                        //       },
                        //     );
                      },
                      child: Text('Accept Order'),
                    ),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
