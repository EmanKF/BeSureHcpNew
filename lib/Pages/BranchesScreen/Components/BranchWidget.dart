import 'dart:developer';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/Components/DeleteBranchDialog.dart';
import 'package:besure_hcp/Pages/BranchesScreen/EditBranchScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:text_scroll/text_scroll.dart';

class BranchWidget extends StatefulWidget {
  const BranchWidget({super.key, this.branch});

  final Branch? branch;

  @override
  State<BranchWidget> createState() => _BranchWidgetState();
}

class _BranchWidgetState extends State<BranchWidget> {
      
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('2'),
      // onDismissed: (direction) async{
      // //  bool res = await deleteBranch(widget.branch!.id!);
      // //  if(res == true){
      // //   BranchesScreen.allBranches.remove(widget.branch);
      // //   BranchesScreen.approvedBranches.remove(widget.branch);
      // //   showDialog(context: context, builder: (context) => MsgDialog(msg: 'Branch deleted successfully',));
      // //  }
      // //  else{
      //   showDialog(context: context, builder: (context) => DeleteBranchDialog(branch: widget.branch!));
      // //  }
      // },
      // confirmDismiss: (direction) async {
      //    bool response = await 
      //                       },
      //                     );
      // },
      // direction: DismissDirection.endToStart,
      // background: Icon(Icons.delete, color: silverLakeBlue),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 5.w,
            ),
             Container(
              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.w : 12.w,
              height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.w : 12.w,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(300.0),
                  child: 
                  widget.branch!.image!.contains('/') || !widget.branch!.image!.contains('.')
                      ? 
                      Image.asset('assets/images/esnadTakaful.png',fit: BoxFit.cover,)
                      : 
                      Image.network(swaggerImagesUrl + "Branches/" + widget.branch!.image!, fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return Icon(Icons.error);
                          },)
                    ),
            ),
             SizedBox(
              width: 2.w,
            ),
            Container(
              width: 43.w,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: SplashScreen.langId == 1? Alignment.centerRight : Alignment.centerLeft,
                        width: 43.w,
                        child: TextScroll( widget.branch!.speciality! != '' ? widget.branch!.name! + ' - ' + widget.branch!.speciality! : widget.branch!.name!, 
                        mode: TextScrollMode.bouncing,
                        velocity: Velocity(pixelsPerSecond: Offset(40, 0)),
                        delayBefore: Duration(milliseconds: 500),
                        pauseBetween: Duration(milliseconds: 500),
                        // textAlign: TextAlign.left,
                        // textAlign: SplashScreen.langId == 1? TextAlign.end : TextAlign.start, 
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.sp : 16.sp, 
                          fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Text(widget.branch!.address!, textAlign: TextAlign.start, style: TextStyle(fontSize: 11.sp))
                  //   ],
                  // ),
                  Row(
                    children: [
                      Text(widget.branch!.mobile!, textAlign: TextAlign.start, style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 11.sp : 16.sp)),
                    ],
                  )
                ],
              ),
            ),
            Spacer(),
            Row(
              children: [
                Container(
                  // height: 6.h,
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0.5.h : 0),
                  decoration: BoxDecoration(
                    color: silverLakeBlue,
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: TextButton(
                    onPressed: () async{
                      String googleMapslocationUrl = "https://www.google.com/maps/search/?api=1&query="+ widget.branch!.lat!.toString() +","+ widget.branch!.long!.toString();
                      String encodedURl = Uri.encodeFull(googleMapslocationUrl);

                          if (await canLaunch(encodedURl)) {
                            await launch(encodedURl);
                          } else {
                            print('Could not launch $encodedURl');
                            throw 'Could not launch $encodedURl';
                          }
                    },
                    child: Text(AppLocalizations.of(context)!.viewOnMap, style: TextStyle(color: Colors.white, 
                    fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 11.sp : 14.sp)),
                  )
                ),
                SizedBox(
                  width: 1.w,
                )
              ],
            ),
             
            if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditBranchScreen(branch: widget.branch)));
                    }, 
                    child: Icon(Icons.edit, color: grey, size: 20)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: (){
                      showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(AppLocalizations.of(context)!.branchDeleteSentence),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)!.yes),
                                    onPressed: () async{
                                      bool res = await deleteBranch(widget.branch!.serviceProviderBranchesId!);
                                      if(res == true){
                                        BranchesScreen.allBranches.remove(widget.branch);
                                        BranchesScreen.approvedBranches.remove(widget.branch);
                                        Observable.instance.notifyObservers([
                                        "_BranchesScreenState",
                                        ], notifyName : "update");
                                        Navigator.pop(context, true);
                                      }
                                      else{
                                        Navigator.pop(context, false);
                                      }
                                    },
                                  ),
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)!.no),
                                    onPressed: () => Navigator.pop(context, false),
                                  ),
                                ],
                              );
                            });
                    }, 
                    child: Icon(Icons.delete, color: grey, size: 20)
                  ),
                ),
              ],
            ),
    
          ],
        ),
      ),
    );
  }
}