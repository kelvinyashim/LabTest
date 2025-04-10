import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_ease/api/patient.dart';
import 'package:test_ease/constants/color.dart';



class LabTestsPriceScreen extends StatelessWidget {
  const LabTestsPriceScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final UserApi userApi = UserApi();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.greenBtn,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Labs Pricing', style: TextStyle(color: Colors.white),)),
      body: FutureBuilder(
        future: userApi.getLabTests(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.greenBtn,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lab tests found.'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final lab = snapshot.data![index];
                  return InkWell(
                    radius: 30,
                    onTap: (){},
                    borderRadius: BorderRadius.circular(30),
                    child: Card(
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)

                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.local_hospital, color: AppColors.greenBtn,),
                        title: Text(
                          lab.lab,
                          style:  GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight:   FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          '${lab.testName}\nPrice: ₦${lab.price}',
                          style:  TextStyle(fontSize: 16, color: Colors.grey[500]),
                        ),
                        trailing: TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            splashFactory: NoSplash.splashFactory
                          ),
                          onPressed: (){}, child: Text('Select Lab',style: TextStyle(color: AppColors.greenBtn),)),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
