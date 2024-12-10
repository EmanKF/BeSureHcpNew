import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/Components/ServiceProvidedWidget.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int selectedBranchId = 0;
  bool isLoading = false;
  List<ServiceModel> servicesByBranch = [];
  int bId = BaseScreen.loggedInSP!.branchId!;
  List<Branch> branchNotAdmin = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(bId != 0){
      for(Branch  b in BranchesScreen.approvedBranches){
        if(b.serviceProviderBranchesId == bId ){
          branchNotAdmin.add(b);
        }
      }
      getServicesPerBranch(bId);
    }
  }

  void getServicesPerBranch(int id) async {
    var getAllApprovedServicesResponse = await http.get(
      Uri.parse(swaggerApiUrl+"ServiceProvideServices/GetAllApprovedServices?LangId=" + SplashScreen.langId.toString() + "&ServiceProviderId="+ BaseScreen.loggedInSP!.serviceProvideId! +"&BranchId=" + id.toString()),
      headers: {
        "Accept": "application/json",
        "content-type":"application/json",
        // "Authorization": "Bearer " + LoginScreen.token
      },
    );
    print(getAllApprovedServicesResponse.body);
    Map getAllApprovedServicesMapResponse = json.decode(getAllApprovedServicesResponse.body);
    if(getAllApprovedServicesMapResponse['httpStatusCode'] == 200){
      servicesByBranch = ServiceModel.listFromJson(getAllApprovedServicesMapResponse['data']);
    }
    else{
      servicesByBranch = List.empty();
    }
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        title: Text(AppLocalizations.of(context)!.activity),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [

             if(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height)
            SizedBox(
              height: 5.h,
            ),
            
            if(bId == 0)
            Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                       width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 80.w : 85.w,
                       child: DropdownButtonFormField( 
                              items: BranchesScreen.approvedBranches.map((Branch value){
                                return new DropdownMenuItem<String>(
                                  value: value.serviceProviderBranchesId.toString(),
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
                                setState(() {
                                  isLoading = true;
                                });
                                print(v.toString());  
                                getServicesPerBranch(int.parse(v.toString()));  
                                setState(() {
                                  selectedBranchId = int.parse(v.toString());
                                  isLoading = false;
                                });                      
                              },

                                hint: Text(AppLocalizations.of(context)!.branch, style:  TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: silverLakeBlue
                                    )
                                ),
                                decoration: InputDecoration( 
                                  prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                  border: OutlineInputBorder(

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: silverLakeBlue, width: 1),
                                ),
                               ),
                            ),                                                                                                                                                                                                                                                                                                
                     ), 

              isLoading == true ?
                Container(
                  height: 70.h,
                  child: Lottie.asset(
                          'assets/animations/loadingStatisticsAnimation.json',
                          width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 60.w,
                          height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 60.w,
                        ),
                )
                      :
              Container(
                height: 70.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for(ServiceModel s in servicesByBranch)
                      ServiceProvidedWidget(service: s)
                    ],
                  ),
                ),
              ),

               ],
            ),


              if(bId != 0)
            Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                       width: MediaQuery.of(context).size.width * 0.85,
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

              Container(
                height: 70.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for(ServiceModel s in servicesByBranch)
                      ServiceProvidedWidget(service: s)
                    ],
                  ),
                ),
              )  
                 ],
            ),    
                 
          ],
        ),
      ),
    );
  }
}
