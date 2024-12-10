import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key, this.service});

  final ServiceModel? service;

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text('Service Details'),
      ),
      body: Container(
        color: Colors.white,
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                Text('Name:', style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600
                )),
                SizedBox(
                  width: 1.w,
                ),
                Text(widget.service!.name!)
              ],
            ),
             Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                Text('Price:', style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600
                )),
                SizedBox(
                  width: 1.w,
                ),
                Text(widget.service!.price!.toString())
              ],
            ),
             Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                Text('Description:', style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600
                )),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                Text(widget.service!.description!, style: TextStyle(
                  fontSize: 12.sp,
                )),
              ],
            ),
            
          ],
        )
      ),
    );
  }
}