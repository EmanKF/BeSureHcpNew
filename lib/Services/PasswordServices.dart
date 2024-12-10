import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:besure_hcp/Constants/constantUrls.dart';

Future<bool> resetPassword(Map map) async {
  var resetPasswordResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProvider/ResetPassword"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json"
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(resetPasswordResponse.body);
  print(resetPasswordResponse.body);
  Map resetPasswordMapResponse = json.decode(resetPasswordResponse.body);
  if (resetPasswordMapResponse["httpStatusCode"] == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> sendCode(Map map) async {
  var verifyResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProvider/SendCode"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json"
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(verifyResponse.body);
  print(verifyResponse.body);
  Map verifyMapResponse = json.decode(verifyResponse.body);
  if (verifyMapResponse["httpStatusCode"] == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> verify(Map map) async {
  var verifyResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProvider/Verfiy"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json"
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(verifyResponse.body);
  print(verifyResponse.body);
  Map verifyMapResponse = json.decode(verifyResponse.body);
  if (verifyMapResponse["httpStatusCode"] == 200) {
    return true;
  } else {
    return false;
  }
}

Future<String> changePassword(Map map) async {
  String res = '';
  var changePasswordResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProvider/ChangePassword"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(changePasswordResponse.body);
  print(changePasswordResponse.body);
  Map changePasswordMapResponse = json.decode(changePasswordResponse.body);
  if (changePasswordMapResponse["httpStatusCode"] == 200) {
     res = changePasswordMapResponse["data"].toString();
  }
  else {
     res = changePasswordMapResponse["message"];
  }
  return res;
}
