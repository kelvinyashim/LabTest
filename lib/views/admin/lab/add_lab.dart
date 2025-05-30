import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/models/lab/labs.dart';
import 'package:test_ease/models/patients/contact_info.dart';
import 'package:test_ease/providers/admin_test_providers.dart';

class AddLab extends StatelessWidget {
  const AddLab({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminTestProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.greenDarkAccentMutedAccent,
        centerTitle: true,
        title: Text('Register a Lab', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () => _showCreateLabModal(context, adminProvider),
          ),
        ],
      ),
      body:
          adminProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : adminProvider.labs.isEmpty
              ? Center(child: Text('Labs not found'))
              : RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async{
                  await adminProvider.getLabs();
                },
                child: ListView.builder(
                  itemCount: adminProvider.labs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(adminProvider.labs[index].name),
                    );
                  },
                ),
              ),
    );
  }

  void _showCreateLabModal(
    BuildContext context,
    AdminTestProvider adminProvider,
  ) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final pswController = TextEditingController();

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
                    "Create New Lab",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenBtn,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: "Lab Name",
                    controller: nameController,
                  ),
                  _buildTextField(
                    label: "Address",
                    controller: addressController,
                  ),
                  _buildTextField(
                    label: "Phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    label: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    label: "Password",
                    controller: pswController,
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: () {
                      final lab = Lab(
                        name: nameController.text,
                        address: addressController.text,
                        contactInfo: ContactInfo(
                          phone: phoneController.text,
                          email: emailController.text,
                        ),
                        password: pswController.text,
                      );
                      adminProvider.createLab(lab);
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
