import 'dart:convert';
import 'dart:developer';

import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Appointment.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;


Future<List<Appointment>> getAllAppointments() async{
  List<Appointment> apps = List.empty(growable: true);  
  String id = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ?  BaseScreen.loggedInSP!.id! : LoginScreen.SPSAID!;
  var getAllAppointmentsResponse = await http.get(
    Uri.parse(swaggerApiUrl + "ClientCard/GetAllPending?SPId=" + id),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getAllAppointmentsResponse.body);
  Map getAllAppointmentsMapResponse = json.decode(getAllAppointmentsResponse.body);
  if(getAllAppointmentsMapResponse['httpStatusCode'] == 200){
    apps = Appointment.listFromJson(getAllAppointmentsMapResponse["data"]);
    return apps;
  }
  else{
    apps = List.empty();
    return apps;
  }
}

Future<bool> UpdateBookingDate(int cardId, String date) async{
  String id = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ? LoginScreen.SPSAID : BaseScreen.loggedInSP!.id!;
  var UpdateAppointmentResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ClientCard/UpdateBookingDate?CardId=" + cardId.toString() + "&ServiceProviderBookDateUserId=" + id + "&BookDate=" + date),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(UpdateAppointmentResponse.body);
  Map UpdateAppointmentMapResponse = json.decode(UpdateAppointmentResponse.body);
  if(UpdateAppointmentMapResponse['httpStatusCode'] == 200){
    // BranchesScreen.allBranches = Branch.listFromJson(getBranchesMapResponse["data"]);
    return true;
  }
  else{
    // BranchesScreen.allBranches = List.empty();
    return false;
  }
}