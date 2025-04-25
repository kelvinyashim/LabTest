import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/providers/patients_provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: patientApi.getPatientOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final orders = snapshot.data;
            return ListView.builder(
              itemCount: orders!.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final status = order.status!;

                if (status.contains('Pending')) {
                  return;
                } else {}
              },
            );
          }
          return Text("");
        },
      ),
    );
  }
}
