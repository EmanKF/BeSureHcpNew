import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;

Future<bool> getAllApprovedBranches() async{
  var getApprovedBranchesResponse = await http.get(
    Uri.parse(swaggerApiUrl + "ServiceProviderBranches/GetAllApprovedBranches?ServiceProviderId=" + BaseScreen.loggedInSP!.serviceProvideId! + "&LangId=" + SplashScreen.langId!.toString()),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // print(getApprovedBranchesResponse.body);
  Map getApprovedBranchesMapResponse = json.decode(getApprovedBranchesResponse.body);
  if(getApprovedBranchesMapResponse['httpStatusCode'] == 200){
    BranchesScreen.approvedBranches = Branch.listFromJson(getApprovedBranchesMapResponse["data"]);
    return true;
  }
  else{
    BranchesScreen.approvedBranches = List.empty();
    return false;
  }
}

Future<bool> getAllBranches(String serviceProviderId) async{
  var getBranchesResponse = await http.get(
    Uri.parse(swaggerApiUrl + "ServiceProviderBranches/GetAllBranches?ServiceProviderId=" + serviceProviderId + "&LangId=" + SplashScreen.langId.toString()),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getBranchesResponse.body);
  Map getBranchesMapResponse = json.decode(getBranchesResponse.body);
  if(getBranchesMapResponse['httpStatusCode'] == 200){
    BranchesScreen.allBranches = Branch.listFromJson(getBranchesMapResponse["data"]);
    return true;
  }
  else{
    BranchesScreen.allBranches = List.empty();
    return false;
  }
}

Future<int> addNewBranch(Map map) async{
  var addNewBranchResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProviderBranches/AddBranch"),
    body: json.encode(map),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json",
     "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(addNewBranchResponse.body);
   print(addNewBranchResponse.body);
  Map addNewBranchMapResponse = json.decode(addNewBranchResponse.body);
  if(addNewBranchMapResponse["httpStatusCode"] == 200){
    return addNewBranchMapResponse["data"];
  }
  else{
    return 0;
  }
}

Future<String> addBranchImage(File f, int branchId,var imageBytes, String fileName) async {
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse(swaggerApiUrl + "ServiceProviderBranches/AddBranchImage?Id=" + branchId.toString()),
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
    print("resultt: ");
    print(respStr);
    return respStr; 
       
}

Future<bool> editBranch(Map map) async{
  var editBranchResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProviderBranches/EditBranch"),
    body: json.encode(map),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(editBranchResponse.body);
  Map editBranchMapResponse = json.decode(editBranchResponse.body);
  if(editBranchMapResponse["httpStatusCode"] == 200){
    return true;
  }
  else{
    return false;
  }
}

Future<bool> deleteBranch(int id) async{
  var deleteBranchResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProviderBranches/DeleteBranch?BranchId=" + id.toString()),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(deleteBranchResponse.body);
  Map deleteBranchMapResponse = json.decode(deleteBranchResponse.body);
  if(deleteBranchMapResponse["httpStatusCode"] == 200){
    return true;
  }
  else{
    return false;
  }
}