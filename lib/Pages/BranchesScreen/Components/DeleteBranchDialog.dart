import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class DeleteBranchDialog extends StatelessWidget {
  const DeleteBranchDialog({super.key, this.branch});

  final Branch? branch;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(AppLocalizations.of(context)!.branchDeleteSentence),
      actions: [
        Container(
          padding: EdgeInsets.all(2.w),
          child: InkWell(
            onTap: () async{
              bool res = await deleteBranch(branch!.serviceProviderBranchesId!);
              if(res == true){
                BranchesScreen.allBranches.remove(branch);
                BranchesScreen.approvedBranches.remove(branch);
                Navigator.pop(context);
                showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.branchDeletedSuccessfully));
              }
              else{
                showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.failedToDeleteBranch));
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