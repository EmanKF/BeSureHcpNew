import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddedServiceWidget extends StatelessWidget {
  const AddedServiceWidget({super.key, this.service});

  final ServiceModel? service;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      color: Colors.grey.shade100,
      padding: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? const EdgeInsets.all(0.0) : EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
      child:
          Row(
            children: [
              Text(service!.name!),
              Spacer(),
              Text(service!.price!.toString()),
              SizedBox(
                width: 3.w,
              ),
              InkWell(
                onTap: (){},
                child: Icon(Icons.delete))
            ],
          ),
    );
  }
}