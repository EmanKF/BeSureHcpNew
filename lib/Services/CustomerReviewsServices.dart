import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/CustomerReview.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/HomeScreen/HomeSceen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;

Future<bool> getAllCustomerReviews(int offset, int limit) async{
  var getAllCustomerReviewsResponse = await http.get(
    Uri.parse(swaggerApiUrl + "ClientReview/GetAllClientReview?ServiceProviderId=" + BaseScreen.loggedInSP!.serviceProvideId! + "&LangId=" + SplashScreen.langId.toString() +"&BranchId=" + BaseScreen.loggedInSP!.branchId!.toString() + "&offset=" + offset.toString() + "&limit=" + limit.toString()),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // print(getAllCustomerReviewsResponse.body);
  Map getAllCustomerReviewsMapResponse = json.decode(getAllCustomerReviewsResponse.body);
  // print(getAllCustomerReviewsMapResponse);
  if(getAllCustomerReviewsMapResponse['httpStatusCode'] == 200){
    HomeScreen.allCustomerReviews  = CustomerReview.listFromJson(getAllCustomerReviewsMapResponse["data"]);
    return true;
  }
  else{
    HomeScreen.allCustomerReviews = List.empty();
    return false;
  }
}