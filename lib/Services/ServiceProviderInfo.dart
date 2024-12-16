import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/ServiceProvider.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getServiceProviderBasicInfo(String id) async {
  // print('basicc infoooooo' + '     '+ id);  
  var ServiceProviderInfoResponse = await http.get(
    Uri.parse(
        swaggerApiUrl + "ServiceProvider/GetServiceProviderBasicInfo?Id=" + id + "&LangId=" + SplashScreen.langId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(ServiceProviderInfoResponse.body);
  // print(ServiceProviderInfoResponse.body);
  Map ServiceProviderInfoMapResponse =
      json.decode(ServiceProviderInfoResponse.body);
      // print('basicc infoooooo');
  if (ServiceProviderInfoMapResponse['httpStatusCode'] == 200) {
    BaseScreen.loggedInSP =
        ServiceProvider.fromJson(ServiceProviderInfoMapResponse["data"]);
        // print('hhhhhhhhhhhhhhhhhh'+BaseScreen.loggedInSP!.id.toString());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SPId', BaseScreen.loggedInSP!.id!);
    LoginScreen.SPSAID = ServiceProviderInfoMapResponse["data"]["serviceProvideSuperAdminId"] ?? '';
    await prefs.setDouble('rating',double.parse(ServiceProviderInfoMapResponse["data"]["rate"].toString())?? 0);
    BaseScreen.rating = ServiceProviderInfoMapResponse["data"]["rate"] ?? 0;
    BaseScreen.commission = ServiceProviderInfoMapResponse["data"]["commission"] ?? 0;
    // log(BaseScreen.loggedInSP.toString());
  } else {
    BaseScreen.loggedInSP = ServiceProvider();
  }
}

Future<bool> editServiceProviderInfo(Map map) async {
  var editInfoResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProvider/EditProfile"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // print(editInfoResponse.body);
  Map editInfoMapResponse = json.decode(editInfoResponse.body);
  if (editInfoMapResponse["httpStatusCode"] == 200) {
    return true;
  } else {
    return false;
  }
}
