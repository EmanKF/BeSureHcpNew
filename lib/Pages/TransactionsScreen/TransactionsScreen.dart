import 'dart:ui';

import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/Transaction.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Pages/TransactionsScreen/SingleTransactionScreen.dart';
import 'package:besure_hcp/Services/TransactionsServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});
  static List<Transaction> transactions = [];
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyFrom = GlobalKey();
  GlobalKey keyAfter = GlobalKey();
  DateTime? fromDate, toDate;
  DateTime defaultDate = DateTime.now();
  int selectedBranchId = 0;
  int bId = BaseScreen.loggedInSP!.branchId!;
  List<Branch> branchNotAdmin = [];


   @override
  void initState() {
    diplayTutorial();
    // TODO: implement initState
    super.initState();
    toDate = defaultDate;
    fromDate = defaultDate;
    if(bId != 0){
      for(Branch  b in BranchesScreen.approvedBranches){
        if(b.serviceProviderBranchesId == bId ){
          branchNotAdmin.add(b);
          selectedBranchId = b.id!;
        }
      }
    }
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('TransactionsDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('TransactionsDisplayedBefore',true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.transactions),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
               
                if(bId == 0)
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                         width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 65.w : 85.w,
                         child: DropdownButtonFormField( 
                                items: BranchesScreen.approvedBranches.map((Branch value){
                                  return new DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Container(
                                      width: 160,
                                      child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                  );
                                }).toList(),
                                validator: (val){
                                   if(val == null)
                                   return 'Select Branch';
                                   else return null;
                                },
                                onChanged: (v) async{
                                  print(v.toString());  
                                  // servicesByBranch = await getAllApprovedServices(int.parse(v.toString()));  
                                  setState(() {
                                    selectedBranchId = int.parse(v.toString());
                                  });                      
                                },
        
                                  hint: Text(AppLocalizations.of(context)!.branch, style:  TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade900
                                      )
                                  ),
                                  decoration: InputDecoration( 
                                    prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                    border: OutlineInputBorder(
        
                                    )
                                 ),
                              ),                                                                                                                                                                                                                                                                                                
                       ),
                 if(bId != 0)
                Container(
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                         width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 65.w : 85.w,
                         child: DropdownButtonFormField( 
                         
                                items: branchNotAdmin.map((Branch value){
                                  return new DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Container(
                                      width: 160,
                                      child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                  );
                                }).toList(),
                                validator: (val){
                                   if(val == null)
                                   return 'Select Branch';
                                   else return null;
                                },
                                onChanged: null,
        
                                  hint: Text(branchNotAdmin.isEmpty ? '' : branchNotAdmin.first.name!, style:  TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade900
                                      )
                                  ),
                                  decoration: InputDecoration( 
                                    prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                    border: OutlineInputBorder(
        
                                    )
                                 ),
                              ),                                                                                                                                                                                                                                                                                                
                       ),
        
        
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    key: keyFrom,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade500 )
                            )
                          ),
                          width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 24.w : 40.w,
                          child: TextButton(
                          onPressed: () async{
                                final DateTime? picked = await showDatePicker(
                                          helpText: AppLocalizations.of(context)!.from,
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2024)
                                              .add(const Duration(days: 360)),
                                          );
                                      if (picked != null) {
                                        if(picked.isAfter(toDate!)){
                                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.dateValidationFrom));
                                          print('nooooooooooooo');
                                        }
                                        else{
                                        setState(() {
                                          fromDate = picked;
                                        });
                                        }
                                      }
                            },
                            
                            child: Row(
                              children: [
                                Icon(Icons.event, color: Colors.grey.shade600,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    fromDate != null ? fromDate.toString().split(' ').first.toString() : defaultDate.toString().split(' ').first.toString(),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                ),
                              ],
                            )),
                          ),
        
                Container(
                  key: keyAfter,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade500 )
                        )
                      ),
                     width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 24.w : 40.w,
                      child: TextButton(
                      onPressed: () async{
                         final DateTime? picked = await showDatePicker(
                                      helpText: AppLocalizations.of(context)!.to,
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2024)
                                          .add(const Duration(days: 360)));
                                  if (picked != null) {
                                     if(picked.isBefore(fromDate!)){
                                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.dateValidationTo));
                                          print('nooooooooooooo');
                                        }
                                        else{
                                        setState(() {
                                          toDate = picked;
                                        });
                                        }
                                  }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.event, color: Colors.grey.shade600,),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                toDate != null ? toDate.toString().split(' ').first.toString() : defaultDate.toString().split(' ').first.toString(),
                                textScaleFactor: 1.0,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        )),
                      ),
        
                ],
              ),
        
              SizedBox(
                height: 2.h,
              ),
        
              Container(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 65.w : 85.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: silverLakeBlue
                ),
                child: TextButton(
                  onPressed: () async{
                    
                    if(fromDate == null || toDate == null){
                      showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                    }
                    else{
                      bool res = await getTransactions(fromDate!.toIso8601String(), toDate!.toIso8601String(), bId);
                      setState(() {
                        
                      });
                    }
        
                  }, 
                  child: Text(AppLocalizations.of(context)!.getTransactions, style: TextStyle(color: Colors.white),))
              ),
              SizedBox(
                height: 2.h,
              ),

              if(TransactionsScreen.transactions.isNotEmpty)
              for(Transaction t in TransactionsScreen.transactions)
              Container(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 65.w : 85.w,
                child: Row(
                  children: [
                     Container(
                      margin: EdgeInsets.all(1.w),
                      padding: EdgeInsets.all(1.w),
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                      height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(300.0),
                          child: 
                            t.profile!.contains('/') || ! t.profile!.contains('.') || t.profile! == ''
                              ? 
                              Image.asset('assets/images/esnadTakaful.png')
                              : 
                              Image.network(swaggerImagesUrl + "Profiles/" + t.profile!, fit: BoxFit.cover)
                            ),
                    ),
                
                    Text(t.fullName.toString()),

                    Spacer(),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => SingleTransactionScreen(transaction: t))));
                      },
                      child: Icon(Icons.inventory_2_outlined, color: grey))
                  ],
                ),
              )
        
            ],
          ),
        ),
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: azureishBlue,
      // textSkip: SplashScreen.langId! == 1 ? "تخطي" : "SKIP", 
      skipWidget: Row(mainAxisAlignment: MainAxisAlignment.end,children: [Text(SplashScreen.langId! == 1 ? "تخطي" : "SKIP")]),
      // alignSkip: SplashScreen.langId! == 1 ? Alignment.topLeft : Alignment.topRight,
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyFrom",
        keyTarget: keyFrom,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(AppLocalizations.of(context)!.fromkeysentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyAfter",
        keyTarget: keyAfter,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(AppLocalizations.of(context)!.afterkeysentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                 
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }
}