import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/admin/test_catalogue.dart';
import 'package:test_ease/providers/admin_test_providers.dart';

class AddTestView extends StatelessWidget {
  const AddTestView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminprovider = Provider.of<AdminTestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.greenBtn,
        title: Text("Add Tests", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              _showCreateLabModal(context, adminprovider);
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body:
          adminprovider.isLoading
              ? Center(child: CircularProgressIndicator())
              : adminprovider.testCatalogue.isEmpty
              ? Center(child: Text("No available tests"))
              : ListView.builder(
                itemCount: adminprovider.testCatalogue.length,
                itemBuilder: (context, index) {
                  final test = adminprovider.testCatalogue[index];
                 return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: Icon(
                        Icons.medication,
                        color: AppColors.greenBtn,
                        size: 32,
                      ),
                      title: Text(
                        test.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        textAlign: TextAlign.left,
                        test.description!,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  void _showCreateLabModal(
    BuildContext context,
    AdminTestProvider adminProvider,
  ) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    "Add New Test",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenBtn,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: "Test Name",
                    controller: nameController,
                  ),
                  _buildTextField(
                    label: "Description",
                    controller: descriptionController,
                  ),

                  SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: () {
                      final test = TestCatalogue(
                        name: nameController.text,
                        description: descriptionController.text,
                      );
                      adminProvider.addTest(test);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenBtn,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text(
                      "Save Lab",
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
    int maxLines = 2,
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
