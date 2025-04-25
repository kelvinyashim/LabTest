// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class StepSubmitOrder extends StatelessWidget {
//   const StepSubmitOrder({super.key});


//   @override
//   Widget build(BuildContext context) {
//     final step = Provider.of<St>(context, listen: false);
//     return Step(
//       state: step.currentstep > 2 ? StepState.complete : StepState.indexed,
//       title: FittedBox(child: Text("Submit order",style: TextStyle(fontSize: 13),)),
//       isActive: step.currentstep >= 2,
//       stepStyle: StepStyle( connectorColor: step.currentstep > 2
//             ? AppColors.greenBtn
//             : Colors.grey,),
//       content: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           boxShadow:  [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: Column(children: [Text('Hello')]),
//       ),
//     ),();
//   }
// }