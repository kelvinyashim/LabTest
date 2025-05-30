import 'package:flutter/material.dart';
import 'package:test_ease/views/admin/lab/add_lab.dart';
import 'package:test_ease/views/admin/add_test_view.dart';
import 'package:test_ease/views/admin/data/grid_admin_data.dart';
import 'package:test_ease/views/admin/grid_item.dart';
import 'package:test_ease/views/admin/users_view.dart';

class AdminGridView extends StatelessWidget {
  const AdminGridView({super.key});

  @override
  Widget build(BuildContext context) {
    void changeRoute(String title) {
      switch (title) {
        case 'Labs':
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddLab(),));
           break; case 'Users':
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsersView(),));
           break; case 'Add Test':
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTestView(),));
           break;
           
        
      }
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      padding: EdgeInsets.all(12),
      itemCount: gridAdminData.length,
      itemBuilder:
          (context, index) => AdminGridItem(
            assetImage: gridAdminData[index]['asset'],
            text: gridAdminData[index]['title'],
            ontap: () {
              changeRoute(gridAdminData[index]['title']);
            },
          ),
    );
  }
}
