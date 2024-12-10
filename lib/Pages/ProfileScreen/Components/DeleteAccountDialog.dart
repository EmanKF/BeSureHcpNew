import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      contentPadding: EdgeInsets.all(15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: 
        [
          Text('Are you sure you want to delete your account?', textAlign: TextAlign.justify,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text('Yes')
              ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('No')
            ),
            ],
          )

        ],
      ),
    );
  }
}