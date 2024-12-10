import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/ServicesProvidedScreen.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:sizer/sizer.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, this.service});

  final ServiceModel? service;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(AppLocalizations.of(context)!.serviceDeleteSentence),
      actions: [
        Container(
          padding: EdgeInsets.all(2.w),
          child: InkWell(
            onTap: () async{
              bool res = await DeleteService(service!.serviceProviderServicesId!);
              if(res == true){
                ServicesProvidedScreen.allServices.remove(service!);
                 Observable.instance.notifyObservers([
                  "_ServicesProvidedScreenState",
                  ], notifyName : "update");
                Navigator.pop(context);
                showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.serviceDeletedSuccessfully));
              }
            },
            child: Text(AppLocalizations.of(context)!.yes)),
        ),
        Container(
          padding: EdgeInsets.all(2.w),
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.no)),
        )
      ],
    );
  }
}