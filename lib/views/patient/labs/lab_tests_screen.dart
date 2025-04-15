import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/providers/admin_test_providers.dart';
import 'package:test_ease/views/patient/labs/labs_testPrice.dart';

class LabTestsScreen extends StatelessWidget {
  const LabTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testCatProvider = Provider.of<AdminTestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Container(
            height: 10,
            decoration: BoxDecoration(
                color: AppColors.greenBtn,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60))),
          ),
        ),
        backgroundColor: AppColors.greenBtn,
        centerTitle: true,
        title: const Text(
          'Lab Tests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: testCatProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.greenBtn,
            ))
          : testCatProvider.testCatalogue.isEmpty
              ? const Center(
                  child: Text(
                  'No Lab Tests Found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Custom Search Bar with enhanced styling
                      Container(
                        margin: const EdgeInsets.only(bottom: 17),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search,
                                color: Colors.grey, size: 30),
                            hintText: 'Search Lab Tests',
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: testCatProvider.testCatalogue.length,
                          itemBuilder: (context, index) {
                            final test = testCatProvider.testCatalogue[index];
                             
                            final id = test.id;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                leading: Icon(Icons.medication,
                                    color: AppColors.greenBtn, size: 32),
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
                                    
                                  )
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    size: 20, color: Colors.grey),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LabTestsPriceScreen(
                                            id: id!,
                                          )));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
