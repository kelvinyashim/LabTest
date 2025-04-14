import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';

class LabDetailsScreen extends StatelessWidget {
  const LabDetailsScreen({super.key, required this.labId});
  final String labId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: FutureBuilder(
        future: patientApi.getLabInfo(labId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final lab = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 3,
                  backgroundColor: AppColors.greenBtn,
                  floating: true,
                  pinned: true,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      textAlign: TextAlign.center,
                      lab.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    background: Container(
                      color: AppColors.greenBtn,
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoCard("Status", lab.status, Icons.verified, Colors.green),
                        const SizedBox(height: 12),
                        _buildInfoCard("Name", lab.name, Icons.local_hospital),
                        const SizedBox(height: 12),
                        _buildInfoCard("Address", lab.address, Icons.location_on),
                        const SizedBox(height: 12),
                        _buildInfoCard("Phone", lab.contactInfo.phone, Icons.phone),
                        const SizedBox(height: 12),
                        _buildInfoCard("Email", lab.contactInfo.email ?? "Not Available", Icons.email),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return const Center(child: Text("No data found."));
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, [Color? iconColor]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? AppColors.greenBtn, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    )),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
