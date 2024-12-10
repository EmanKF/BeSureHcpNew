import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Services/ReconcilationReportsServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DisapprovePopUp extends StatefulWidget {
  DisapprovePopUp({super.key, this.id});

  int? id;

  @override
  State<DisapprovePopUp> createState() => _DisapprovePopUpState();
}

class _DisapprovePopUpState extends State<DisapprovePopUp> {
  TextEditingController text = new TextEditingController();
  bool isDone=true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              child: Text('Disapprove Reconcilation:'),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                maxLines: 2,
                controller: text,
                decoration: InputDecoration(
                prefixIcon: Icon(Icons.description),
                hintText: 'Reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: silverLakeBlue, width: 1),
                ),
              ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: silverLakeBlue,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(
                    onPressed: () async{
                      setState(() {
                        isDone = false;
                      });
                      await approveReconcilation(widget.id!, false, text.text);
                      Observable.instance.notifyObservers([
                          "_PreReconcilationScreenState",
                          ], notifyName : "update"); 
                      setState(() {
                        isDone = true;
                      });
                      Navigator.pop(context);
                    }, 
                    child: isDone == false? LoadingAnimationWidget.waveDots(color: Colors.white, size: 20)
                    : Text('Send', style: TextStyle(color: Colors.white),)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}