// import 'package:besure_businessapp/Constants/constantColors.dart';
// import 'package:besure_businessapp/Models/Service.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class ServiceWidget extends StatelessWidget {
//   const ServiceWidget({super.key, this.service});

//   final ServiceModel? service;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(2.w),
//       padding: EdgeInsets.all(3.w),
//       width: 85.w,
//       decoration: BoxDecoration(
//           color: azureishBlue, borderRadius: BorderRadius.circular(300.0)),
//       child: Row(
//         children: [
//           Container(
//             width: 15.w,
//             height: 15.w,
//             decoration: BoxDecoration(shape: BoxShape.circle),
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(300.0),
//                 child: 
//                 // service!.image!.contains('.')
//                     // ?
//                      Image.asset('assets/images/esnadTakaful.png')
//                     // : Image.network(service!.image!)
//                   ),
//           ),
//           Container(
//             width: 60.w,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 5.w,
//                     ),
//                     Text(
//                       service!.name!,
//                       style: TextStyle(fontSize: 12.sp),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 5.w,
//                     ),
//                     Text(
//                       service!.description!,
//                       style: TextStyle(fontSize: 10.sp),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
