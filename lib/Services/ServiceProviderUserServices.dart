import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Functions/parseTokenFunction.dart';
import 'package:besure_hcp/Models/ServiceProvider.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/ManageAccountsScreen/ManageAccountsScreen.dart';
import 'package:http/http.dart' as http;
import '../Models/SPUSer.dart';

Future<bool> getAllSPUsers() async{
  var getAllSPUsersResponse = await http.get(
    Uri.parse(swaggerApiUrl+"ServiceProviderUser/GetAllEmployee?ServiceProviderId="+BaseScreen.loggedInSP!.id!),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(getAllSPUsersResponse.body);
  Map getAllSPUsersMapResponse = json.decode(getAllSPUsersResponse.body);
  if(getAllSPUsersMapResponse['httpStatusCode'] == 200){
    ManageAccountsScreen.sPUsers = ServiceProvider.listFromJson(getAllSPUsersMapResponse['data']);
    return true;
  }
  else{
    ManageAccountsScreen.sPUsers = List.empty();
    return false;
  }
}

Future<String> addSPUser(Map map) async{
  String uId ='';
  var addSPUserResponse = await http.post(
    Uri.parse(swaggerApiUrl+"ServiceProviderUser/Register"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(addSPUserResponse.body);
  // print(addSPUserResponse.body);
  Map addSPUserMapResponse = json.decode(addSPUserResponse.body);
  if(addSPUserMapResponse['httpStatusCode'] == 200){
    Map<String, dynamic> res = parseJwt(addSPUserMapResponse['data']);
    uId = res['Id'];
    return uId;
  }
  else{
    return uId;
  }
}

Future<String> addUserImage(File f, String userId) async {
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse(swaggerApiUrl + "ServiceProvider/SaveImage?Id=" + userId),
      
    );
    request.headers.addAll({"Authorization" : "Bearer " + LoginScreen.token});
    request.headers.addAll({"content-type": "multipart/form-data"});
    request.files.add(await http.MultipartFile.fromPath("Image", f.path));
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    return respStr;    
}

Future<bool> deleteSPUser(String userId) async{
  var deleteSPUserResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProviderUser/DeleteAccount?UserId=" + userId),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(deleteSPUserResponse.body);
  Map deleteSPUserMapResponse = json.decode(deleteSPUserResponse.body);
  if(deleteSPUserMapResponse["httpStatusCode"] == 200){
    return true;
  }
  else{
    return false;
  }
}

Future<bool> editSPUser(Map map) async {
  // log(json.encode(map));
  var editInfoResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProviderUser/EditProfile"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(editInfoResponse.body);
  Map editInfoMapResponse = json.decode(editInfoResponse.body);
  if (editInfoMapResponse["httpStatusCode"] == 200) {
    return true;
  } else {
    return false;
  }
}
