import 'dart:convert';
import 'dart:developer';

import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;


Future<bool> payCash(String clientId, int cardId) async {
  log(swaggerApiUrl + "ClientCard/PayCashClientCard?ClientId" + clientId +"&ClientCardId=" + cardId.toString());
  var payCashResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ClientCard/PayCashClientCard?ClientId=" + clientId +"&ClientCardId=" + cardId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(payCashResponse.body);
  // print(getCitiesResponse.body);
  Map payCashResponseMapResponse = json.decode(payCashResponse.body);
  if(payCashResponseMapResponse['httpStatusCode'] == 200){
    return true;
  }
  else return false;
}

Future<String> payCredit(Map map) async {
  var payCreditResponse = await http.post(
    Uri.parse(swaggerApiUrl+"General/GetClientCardPaymentData"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  log(payCreditResponse.body);
  print(payCreditResponse.body);
  String payCreditResponseMapResponse = json.decode(payCreditResponse.body);
  if(payCreditResponseMapResponse != null){
    return payCreditResponseMapResponse;
  }
  else return '';
}
