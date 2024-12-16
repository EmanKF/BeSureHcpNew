import 'dart:convert';
import 'dart:developer';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/UploadBillScreen.dart';
import 'package:besure_hcp/Services/PaymentServices.dart';
import 'package:besure_hcp/configure_ws.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationPopUp extends ConsumerStatefulWidget {
  ConfirmationPopUp({super.key, this.name, this.cardId, this.clientID});
  String? name, clientID;
  int? cardId;


  @override
  ConsumerState<ConfirmationPopUp> createState() => _ConfirmationPopUpState();
}

class _ConfirmationPopUpState extends ConsumerState<ConfirmationPopUp> {

  Future<void> sendWebSocketMessage() async{
    var onesignalId = await OneSignal.User.getOnesignalId() ?? 'N/A';
    log(onesignalId+' on send msg');
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('SPId') ?? '';
        final message = {
          "Id":0,
          "Action":"ClientCardRate",
          "Message":"ClientCardRate",
          "ClientPoints":0,
          "ClientName_en":widget.name,
          "SPName_en":"",
          "ClientName":widget.name,
          "SPName":"",
          "SPPoints":0,
          "SP": id,
          "SPDeviceId":onesignalId,
          "Client": widget.clientID,
          "Data":["String"],
          "ClientCard": [],
          "ClientCardId" : widget.cardId,
          "PaymentUrl": ""
        };
            
            log(message.toString());
          ref.read(websocketProvider).sendMessage(jsonEncode(message));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Text(AppLocalizations.of(context)!.areYouSure),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async{
                    bool res = await payCash(widget.clientID! ,widget.cardId!);
                    if(res == true){
                      await sendWebSocketMessage();
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UploadBillScreen(cardId: widget.cardId)));
                    }
                  }, 
                  child: Text(AppLocalizations.of(context)!.yes)),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Text(AppLocalizations.of(context)!.no))
              ],
            )
          ],
        ),
      ),
    );
  }
}