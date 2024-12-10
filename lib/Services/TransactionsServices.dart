import 'dart:convert';
import 'dart:developer';

import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/ClientCard.dart';
import 'package:besure_hcp/Models/Transaction.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/TransactionsScreen/TransactionsScreen.dart';
import 'package:http/http.dart' as http;

Future<bool> getTransactions(String from, String to, int branchId) async {
  List? list = [];
  if(branchId != 0){
    list.add(branchId);
  }
  else list = null;
  
  var transactionsResponse = await http.post(
    Uri.parse(
        swaggerApiUrl + "ServiceProvider/GetAllVistedClients?offset=0&limit=100&ServiceProviderId=" + BaseScreen.loggedInSP!.serviceProvideId! + "&From=" + from + "&To=" + to),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
    body: json.encode(list)
    
  );
    log(swaggerApiUrl + "ServiceProvider/GetAllVistedClients?offset=0&limit=100&ServiceProviderId=" + BaseScreen.loggedInSP!.serviceProvideId! + "&From=" + from + "&To=" + to);

  log(transactionsResponse.body);
  Map transactionsResponseMap =
      json.decode(transactionsResponse.body);
  if (transactionsResponseMap['httpStatusCode'] == 200) {
    TransactionsScreen.transactions = Transaction.listFromJson(transactionsResponseMap['data']);
    return true;
  }
  else{
    TransactionsScreen.transactions = [];
    return false;
  }
}


Future<ClientCard> getClientCard(int cardId) async {
  ClientCard clientCard = ClientCard();
  // log(cardId.toString());
  var getClientCardResponse = await http.get(
    Uri.parse(
        swaggerApiUrl + "ClientCard/GetClientCard?Id=" + cardId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getClientCardResponse.body);
  Map getClientCardResponseMap =
      json.decode(getClientCardResponse.body);
  if (getClientCardResponseMap['httpStatusCode'] == 200) {
    clientCard = ClientCard.fromJson(getClientCardResponseMap['data']);
  }
  else{
    clientCard = ClientCard.fromJson(getClientCardResponseMap['data']);
  }
  return clientCard;
}