import 'dart:convert';
import 'dart:developer';

import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/ClientReport.dart';
import 'package:besure_hcp/Models/DisplayReconcilation.dart';
import 'package:besure_hcp/Models/ReconcilationObject.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:http/http.dart' as http;

Future<DisplayReconcilation> DisplayClaim(String from, String to) async{
  DisplayReconcilation displayRec;
  log(swaggerApiUrl+"Reconcilation/DisplayClaim?from=" + from + "&to="+ to +"&serviceProviderId=" + BaseScreen.loggedInSP!.id!);
  var displayClaimResponse = await http.post(
    Uri.parse(swaggerApiUrl+"Reconcilation/DisplayClaim?from=" + from + "&to="+ to +"&serviceProviderId=" + BaseScreen.loggedInSP!.id!),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(displayClaimResponse.body);
  print(displayClaimResponse.body);
  Map displayClaimResponseMap = json.decode(displayClaimResponse.body);
  if(displayClaimResponseMap['httpStatusCode'] == 200){
    displayRec = DisplayReconcilation.fromJson(displayClaimResponseMap['data']);
  }
  else{
    displayRec = DisplayReconcilation();
  }
  return displayRec;
}

Future<void> GenerateClaim(int spId, String from, String to) async{
  var generateClaimResponse = await http.post(
    Uri.parse(swaggerApiUrl+"Reconcilation/GenerateClaim?from=" + from + "&to="+ to +"&serviceProviderId=" + BaseScreen.loggedInSP!.id!),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(generateClaimResponse.body);
  print(generateClaimResponse.body);
}

Future<void> UpdateSettelment(num amount, num transfer) async{
  var UpdateSettelmentResponse = await http.post(
    Uri.parse(swaggerApiUrl+"/Reconcilation/UpdateSettlment?id=" + BaseScreen.loggedInSP!.id! + "&SPSetteledAmount="+ amount.toString() +"&transfer=" + transfer.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(UpdateSettelmentResponse.body);
  print(UpdateSettelmentResponse.body);
}

Future<List<ReconcilationObject>> GetAllReconcilation() async{
  List<ReconcilationObject> recList = List.empty(growable: true);
  var getAllReconcilationResponse = await http.get(
    Uri.parse(swaggerApiUrl+"Reconcilation/GetAllReconcilation?spID=" + BaseScreen.loggedInSP!.id!),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(getAllReconcilationResponse.body);
  print(getAllReconcilationResponse.body);
  Map getAllReconcilationResponseMap = json.decode(getAllReconcilationResponse.body);
  if(getAllReconcilationResponseMap['httpStatusCode'] == 200){
    recList = ReconcilationObject.listFromJson(getAllReconcilationResponseMap['data']);
  }
  else{
    recList = List.empty(growable: true);
  }
  return recList;
}

Future<void> approveReconcilation(int id, bool IS_Approved, String transfer) async {
  var approveReconcilationResponse = await http.post(
    Uri.parse(swaggerApiUrl + "Reconcilation/UpdateSettlment?id=" + id.toString() + "&IS_Approved=" + IS_Approved.toString() + "&transfer=" + transfer),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(approveReconcilationResponse.body);
  // print(getCitiesResponse.body);
  // Map approveReconcilationMapResponse = json.decode(approveReconcilationResponse.body);
  // if(payCashResponseMapResponse['httpStatusCode'] == 200){
  //   return true;
  // }
  // else return false;
}