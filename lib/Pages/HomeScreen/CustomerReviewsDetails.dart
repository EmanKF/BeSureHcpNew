import 'package:besure_hcp/Models/CustomerReview.dart';
import 'package:besure_hcp/Pages/HomeScreen/Components/CustomerReviewWidget.dart';
import 'package:besure_hcp/Pages/HomeScreen/HomeSceen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomerReviewsDetails extends StatelessWidget {
  const CustomerReviewsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Customer Reviews'),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: Column(
          children: [
            for( CustomerReview c in HomeScreen.allCustomerReviews)
            CustomerReviewWidget(customerReview: c)
          ],
        ),
      ),
    );
  }
}