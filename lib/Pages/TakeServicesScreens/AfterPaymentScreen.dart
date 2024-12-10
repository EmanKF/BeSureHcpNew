import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class AfterPaymentScreen extends StatelessWidget {
  const AfterPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Payment Succesfull', style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: 26),)),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Lottie.asset(
              'assets/animations/donePayment.json',
              width: 60.w,
              height: 60.w,
            ),
          ),
          Center(child: Text('You can now give services to the patient')),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical:10,horizontal: 20),
              decoration: BoxDecoration(
                color: silverLakeBlue
              ),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BaseScreen()));
                }, 
                child: Text('Ok', style: TextStyle(color: Colors.white),)),
            ),
          )
        ],
      ),
    );
  }
}