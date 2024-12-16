import 'package:flutter/material.dart';

class PaymentFailedDialog extends StatelessWidget {
  const PaymentFailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Text('Payment Failed, try again or use another way to get the money'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async{
                      Navigator.pop(context);
                    },
                  child: Text('Ok')),
              ],
            )
          ],
        ),
      ),
    );
  }
}