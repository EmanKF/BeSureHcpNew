import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/ServicesProvidedScreen.dart';
import 'package:besure_hcp/Pages/ServicesScreen/AllServicesScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;

Future<bool> getAllServices() async{
  // print(BaseScreen.loggedInSP!.id.toString());
  var getAllServicesResponse = await http.get(
    Uri.parse(swaggerApiUrl+"ServiceProvideServices/GetAllServices?LangId=" + SplashScreen.langId.toString() + "&ServiceProviderId="+ BaseScreen.loggedInSP!.serviceProvideId!  +"&BranchId=" + BaseScreen.loggedInSP!.branchId!.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(getAllServicesResponse.body);
  print(getAllServicesResponse.body);
  Map getAllServicesMapResponse = json.decode(getAllServicesResponse.body);
  if(getAllServicesMapResponse['httpStatusCode'] == 200){
    AllServicesScreen.allServices = ServiceModel.listFromJson(getAllServicesMapResponse['data']);
    ServicesProvidedScreen.allServices = ServiceModel.listFromJson(getAllServicesMapResponse['data']);
    return true;
  }
  else{
    AllServicesScreen.allServices = List.empty();
    ServicesProvidedScreen.allServices = List.empty();
    return false;
  }
}

Future<List<ServiceModel>> getAllApprovedServices(int branchId) async{
  List<ServiceModel> services = [];
  var getAllApprovedServicesResponse = await http.get(
    Uri.parse(swaggerApiUrl+"ServiceProvideServices/GetAllApprovedServices?LangId=" + SplashScreen.langId.toString() + "&ServiceProviderId="+ BaseScreen.loggedInSP!.serviceProvideId! +"&BranchId=" + branchId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(swaggerApiUrl+"ServiceProvideServices/GetAllApprovedServices?LangId=" + SplashScreen.langId.toString() + "&ServiceProviderId="+ BaseScreen.loggedInSP!.serviceProvideId! +"&BranchId=" + branchId.toString());
  log(getAllApprovedServicesResponse.body);
  print(getAllApprovedServicesResponse.body);
  Map getAllApprovedServicesMapResponse = json.decode(getAllApprovedServicesResponse.body);
  if(getAllApprovedServicesMapResponse['httpStatusCode'] == 200){
    AllServicesScreen.allApprovedServices = ServiceModel.listFromJson(getAllApprovedServicesMapResponse['data']);
    ServicesProvidedScreen.allApprovedServices = ServiceModel.listFromJson(getAllApprovedServicesMapResponse['data']);
    services = ServiceModel.listFromJson(getAllApprovedServicesMapResponse['data']);
  }
  else{
    AllServicesScreen.allApprovedServices = List.empty();
    ServicesProvidedScreen.allApprovedServices = List.empty();
    services = List.empty();
  }
  return services;
}

Future<int> addService(Map map) async{
  int res = 0;
  // log(json.encode(map).toString());
  var addServiceResponse = await http.post(
    Uri.parse(swaggerApiUrl+"ServiceProvideServices/AddService"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(addServiceResponse.body);
  Map addServiceMapResponse = json.decode(addServiceResponse.body);
  if(addServiceMapResponse['httpStatusCode'] == 200){
    res = addServiceMapResponse["data"];
  }
  else{
    res = 0;
  }
  return res;
}

Future<String> addServiceImage(File f, int serviceId, var imageBytes, String fileName) async {
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse(swaggerApiUrl + "ServiceProvideServices/AddServiceImage?Id=" + serviceId.toString()),
      
    );
    request.headers.addAll({"Authorization" : "Bearer " + LoginScreen.token});
    request.headers.addAll({"content-type": "multipart/form-data"});
    if(imageBytes != ''){
      request.files.add(http.MultipartFile.fromBytes('Image', imageBytes, filename: fileName));
    }
    else{
      request.files.add(await http.MultipartFile.fromPath("Image", f.path));
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    return respStr;    
}

Future<bool> editService(Map map) async{
  var editServiceResponse = await http.post(
    Uri.parse(swaggerApiUrl+"ServiceProvideServices/EditService"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(editServiceResponse.body);
  Map editServiceMapResponse = json.decode(editServiceResponse.body);
  if(editServiceMapResponse['httpStatusCode'] == 200){
    return true;
  }
  else{
    return false;
  }
}

Future<bool> DeleteService(int serviceId) async{
  var DeleteServiceResponse = await http.post(
    Uri.parse(swaggerApiUrl+"ServiceProvideServices/DeleteService?ServiceId=" + serviceId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
    "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(DeleteServiceResponse.body);
  Map DeleteServiceMapResponse = json.decode(DeleteServiceResponse.body);
  if(DeleteServiceMapResponse['httpStatusCode'] == 200){
    return true;
  }
  else{
    return false;
  }
}