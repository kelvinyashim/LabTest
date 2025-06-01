import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/patients/contact_info.dart';
import 'package:test_ease/models/phleb/phleb.dart';
import 'package:test_ease/providers/lab_providers.dart';
import 'package:test_ease/providers/phleb_provider.dart';

class AddPhlebScreen extends StatelessWidget {
  const AddPhlebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phleb = Provider.of<PhlebProvider>(context);
    final lab = Provider.of<LabProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.greenBtn,
        title: const Text(
          "Add Phlebotomist",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showCreateLabModal(context, phleb, lab.lab!.id!);
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: phleb.isLoading
          ? const Center(child: CircularProgressIndicator())
          : phleb.phlebs.isEmpty
              ? const Center(
                  child: Text("No phlebotomists added yet."),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: phleb.phlebs.length,
                  itemBuilder: (context, index) {
                    final gottenPhlebs = phleb.phlebs[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.greenBtn,
                          child: Text(
                            gottenPhlebs.name.isNotEmpty
                                ? gottenPhlebs.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          gottenPhlebs.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16),
                                const SizedBox(width: 5),
                                Text(gottenPhlebs.contactInfo.phone),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.email, size: 16),
                                const SizedBox(width: 5),
                                Text(gottenPhlebs.contactInfo.email!),
                              ],
                            ),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            gottenPhlebs.status!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: gottenPhlebs.status == 'Available'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showCreateLabModal(
    BuildContext context,
    PhlebProvider phleb,
    String id,
  ) {
    final nameController = TextEditingController();
    final pswController = TextEditingController();
    final emailController = TextEditingController();
    final phone = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    "Add Phleb",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenBtn,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(label: "Name", controller: nameController),
                  _buildTextField(label: "Email", controller: emailController),
                  _buildTextField(label: "Phone", controller: phone),
                  _buildTextField(
                      label: "Password", controller: pswController),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      final newPhleb = Phleb(
                        name: nameController.text.trim(),
                        contactInfo: ContactInfo(
                          phone: phone.text.trim(),
                          email: emailController.text.trim(),
                        ),
                        password: pswController.text.trim(),
                        associatedLab: id,
                      );
                      phleb.addPhleb(newPhleb);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenBtn,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.greenBtn),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.greenBtn, width: 2),
          ),
        ),
      ),
    );
  }
}
