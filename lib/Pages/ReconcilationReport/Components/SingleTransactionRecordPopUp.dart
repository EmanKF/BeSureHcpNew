import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/ClientReport.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SingleTransactionRecordPopUp extends StatelessWidget {
  SingleTransactionRecordPopUp({super.key, this.transaction});
  
  ClientReport ? transaction;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(

      ),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(child: Text(AppLocalizations.of(context)!.transactionDetails, style: TextStyle(fontSize: 16),)),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: RichText(text: TextSpan(
                children: [
                  TextSpan(text: AppLocalizations.of(context)!.name+': ', style: TextStyle(color: silverLakeBlue)),
                  TextSpan(text: transaction!.clientName!, style: TextStyle(color: Colors.black))
                ] )),
            ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                child: RichText(text: TextSpan(
                children: [
                  TextSpan(text: AppLocalizations.of(context)!.branch+': ', style: TextStyle(color: silverLakeBlue)),
                  TextSpan(text: transaction!.serviceProviderBranchName!, style: TextStyle(color: Colors.black))
                ] )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                child: RichText(text: TextSpan(
                children: [
                  TextSpan(text: AppLocalizations.of(context)!.paymentMethod+': ' , style: TextStyle(color: silverLakeBlue)),
                  TextSpan(text: transaction!.is_Paid_By_Amazon! == true ? AppLocalizations.of(context)!.besure : AppLocalizations.of(context)!.cash, style: TextStyle(color: Colors.black))
                ] )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35.w,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),
                        right: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),
                        top: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),
                      )
                    ),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.amountSar),
                        Text(transaction!.amount!.toString())
                      ]),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 35.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),
                        top: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),
                      )
                    ),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.discountPercentage),
                        Text(transaction!.discount!.toString())
                      ]),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 35.w,
                   decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),
                        bottom: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),
                      )
                    ), 
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.centerSar),
                        Text(transaction!.centerAmount!.toString())
                      ]),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 35.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: azureishBlue,
                          width: 1
                        ),)
                    ),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.beSureSar),
                        Text((transaction!.amount! - transaction!.centerAmount!).toString())
                      ]),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              )
          ],
        ),
      ), 
    );
  }
}