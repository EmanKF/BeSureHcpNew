import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/AfterPaymentScreen.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/Components/PaymentFailedDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class PayingDialog extends StatefulWidget {
  PayingDialog({super.key, this.name});
  
  String? name; 

  @override
  State<PayingDialog> createState() => _PayingDialogState();
}

class _PayingDialogState extends State<PayingDialog> with Observer {
  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
    goNext();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  goNext() async{
    await Future.delayed(Duration(seconds: 2));
    // Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder: ((context) => TakeServicesScreen(sObj: widget.sObj))));
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:  Colors.white,

      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Container(
            margin: EdgeInsets.all(15),
            child: Text(widget.name! + ' is paying to BeSure', style: TextStyle(fontSize: 16, color: silverLakeBlue, fontWeight: FontWeight.bold),)),
          Container(
            child: Lottie.asset(
              'assets/animations/paying.json',
              width: 80.w,
              height: 80.w,
            ),
          ),
        ],
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    if(map!['action'] == 'PaymentSuccess'){
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AfterPaymentScreen()));
    }
    else if(map['action'] == 'PaymentFailed'){
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => PaymentFailedDialog());
    }
  }
}