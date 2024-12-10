import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Notification.dart';
import 'package:http/http.dart' as http;

List<Notification> notifications = [];

void getNotifications(String serviceProviderId) async{
  var getNotificationsResponse = await http.get(
    Uri.parse(swaggerApiUrl + "ServiceProvider/GetMyNotifications?UserId=" + serviceProviderId),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getNotificationsResponse.body);
  Map getNotificationsMapResponse = json.decode(getNotificationsResponse.body);
  if(getNotificationsMapResponse['httpStatusCode'] == 200){
    notifications = Notification.listFromJson(getNotificationsMapResponse["data"]);
  }
  else{
    notifications = List.empty();
  }
}