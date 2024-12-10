import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/ScanQrObject.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:http/http.dart' as http;

Future<ScanQrObject> CheckVerificationIdIfEligible(String clientId) async {
  log(swaggerApiUrl + "ServiceProvider/CheckIfEligible?IdNb="+ clientId +"&ServiceProviderId=" + BaseScreen.loggedInSP!.serviceProvideId!);
  var CheckVerificationIdIfEligibleResponse = await http.get(
    Uri.parse( swaggerApiUrl + "ServiceProvider/CheckIfEligible?IdNb="+ clientId +"&ServiceProviderId=" + BaseScreen.loggedInSP!.serviceProvideId!),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    }, 
  );
  print(CheckVerificationIdIfEligibleResponse.body);
  Map CheckVerificationIdIfEligibleMapResponse =
      json.decode(CheckVerificationIdIfEligibleResponse.body);
   ScanQrObject s;
  if (CheckVerificationIdIfEligibleMapResponse['data'] != null) {
   s = ScanQrObject.fromJson(CheckVerificationIdIfEligibleMapResponse['data']);
    return s;
  } else {
    s = ScanQrObject(clientId: '', name: '', discount: 0);
    return s;
  }
}

Future<num?> checkIfEligibleService(String clientId, int serviceId) async {
  // print(clientId);
  // print(serviceId.toString());
  log(swaggerApiUrl + "ServiceProvider/CheckIfEligibleService?Id="+ clientId +"&ServiceId="+serviceId.toString());
  var CheckVerificationIdIfEligibleResponse = await http.get(
    Uri.parse( swaggerApiUrl + "ServiceProvider/CheckIfEligibleService?Id="+ clientId +"&ServiceId="+serviceId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  print(CheckVerificationIdIfEligibleResponse.body);
   Map CheckVerificationIdIfEligibleMapResponse =
      json.decode(CheckVerificationIdIfEligibleResponse.body);
   num dis = CheckVerificationIdIfEligibleMapResponse["data"]["discount"];
   return dis;
}

Future<int> AddClientCard(Map map) async {
  // log(json.encode(map));
  var addClientCardResponse = await http.post(
    Uri.parse( swaggerApiUrl + "ClientCard/AddClientCard"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(addClientCardResponse.body);
  // print(addClientCardResponse.body);
  Map addClientCardMapResponse =
      json.decode(addClientCardResponse.body);
  if (addClientCardMapResponse['httpStatusCode'] == 200) {
    return addClientCardMapResponse['data'];
  } else {
    return 0;
  }
}

Future<String> uploadBill(int cardId, File f) async {
   http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse(swaggerApiUrl + "ClientCard/UploadBillServiceProvider?CardId=" + cardId.toString()),
      
    );
    request.headers.addAll({"Authorization" : "Bearer " + LoginScreen.token});
    request.headers.addAll({"content-type": "multipart/form-data"});
    request.files.add(await http.MultipartFile.fromPath("Bill", f.path));
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("resultt: ");
    print(respStr);
    return respStr;    
}

  Future<bool> cancelClientCard(int cardId) async {
     var cancelCardResponse = await http.post(
    Uri.parse( swaggerApiUrl + "ClientCard/CancelClientCard?ClientCardId=" + cardId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );

  //  print(cancelCardResponse.body);
   Map cancelCardResponseMap = json.decode(cancelCardResponse.body);
   bool res = cancelCardResponseMap["data"];
   return res;   
}

// Future<bool> getDiscount(double amount, String clientId) async {
//   var getDiscountResponse = await http.get(
//     Uri.parse( swaggerApiUrl + "ServiceProvider/GetDiscount?ClientId=" + clientId + "&Amount="+amount.toString()),
//     headers: {
//       "Accept": "application/json",
//       "content-type": "application/json",
//       "Authorization": "Bearer " + LoginScreen.token
//     },
//   );
//   log(getDiscountResponse.body);
//   Map getDiscountMapResponse =
//       json.decode(getDiscountResponse.body);
//   if (getDiscountMapResponse['httpStatusCode'] == 200) {
//     return true;
//   } else {
//     return false;
//   }
// }