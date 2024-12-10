import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/CustomerReview.dart';
import 'package:besure_hcp/Pages/HomeScreen/Components/CustomerReviewWidget.dart';
import 'package:besure_hcp/Pages/HomeScreen/HomeSceen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllCustomerReviewsScreen extends StatelessWidget {
  const AllCustomerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        title: Text(AppLocalizations.of(context)!.customerReviews),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        width: 100.w,
        height: 100.h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for(CustomerReview cr in HomeScreen.allCustomerReviews)
              CustomerReviewWidget(customerReview: cr),
           ]
          ),
        ),
      ),
    );
  }
}