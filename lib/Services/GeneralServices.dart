import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/City.dart';
import 'package:besure_hcp/Models/Gender.dart';
import 'package:besure_hcp/Models/Language.dart';
import 'package:besure_hcp/Models/ServiceType.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/HomeScreen/HomeSceen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart' show parse;

String htmlToText(String html) {
  var document = parse(html);
  String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

List<Language> languages = [];

Future<void> getAllLanguages() async {
  // print('ftnaaa');
  try{
  var languagesResponse = await http.get(
    Uri.parse(swaggerApiUrl + "General/GetAllLanguages"),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
 
  if(languagesResponse.statusCode == 200){
  //    print('5lsna');
  //   log(languagesResponse.body);
    print(languagesResponse.body);
    Map languagesMapResponse = json.decode(languagesResponse.body);
    if(languagesMapResponse['httpStatusCode'] == 200){
    List<dynamic> list = languagesMapResponse["data"];
      languages = Language.listFromJson(list);
      // log('Languages ::: ' + languages.toString());
    }
  }
  else{
    // print(languagesResponse.statusCode);
    // print('akalna tarabesh');
    languages = [
      Language(id: 1, name: 'English', languageCode: 'en', flag: '🇺🇸', is_ltr: false),
      Language(id: 2, name: 'العربية', languageCode: 'ar', flag: '🇸🇦', is_ltr: true)
    ];
  }
  }
  catch(er){
    // print(er);
  }
}

Future<void> refreshToken() async {
  Map map = Map();
  map["token"] = LoginScreen.token;
  map["refreshToken"] = LoginScreen.refreshToken;
  // print(json.encode(map));
  var refreshTokenResponse = await http.post(
    Uri.parse(swaggerApiUrl + "ServiceProvider/RefreshToken"),
    body: json.encode(map),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    },
  );
  // log(refreshTokenResponse.body);
  Map refreshTokenMapResponse = json.decode(refreshTokenResponse.body);
  if(refreshTokenMapResponse['httpStatusCode'] == 200){
    if(refreshTokenMapResponse['message'] != 'df_success'){
      final prefs = await SharedPreferences.getInstance();
      String token = refreshTokenMapResponse['data']['token'];
      String refreshToken = refreshTokenMapResponse['data']['refreshToken'];
      LoginScreen.token = token;
      LoginScreen.refreshToken = refreshToken;
      await prefs.setString('token',token);
      await prefs.setString('refreshToken', refreshToken);
    }
  }
}

void readLabels() async {
  var response = await http.get(
    Uri.parse("http://api.esnadtakaful.com/labellabel_en.json"),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
    );
  // log(response.body);
  // File file = File('lib/en.json'); //load the json f
  // file.writeAsStringSync(json.encode(response.body));
}

void getAllCities() async {
  var getCitiesResponse = await http.get(
    Uri.parse(swaggerApiUrl + "General/GetAllCities?LangId=" + SplashScreen.langId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getCitiesResponse.body);
  // print(getCitiesResponse.body);
  Map getCitiesMapResponse = json.decode(getCitiesResponse.body);
  if(getCitiesMapResponse['httpStatusCode'] == 200){
   List<dynamic> list = getCitiesMapResponse["data"];
    BaseScreen.allCities = City.listFromJson(list);
    // log('Cities ::: ' + BaseScreen.allCities.toString());
  }
  else{
    BaseScreen.allCities = List.empty();
  }
}

void getAllGenders() async {
  var getGendersResponse = await http.get(
    Uri.parse(swaggerApiUrl + "General/GetAllGender?LangId="+ SplashScreen.langId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getGendersResponse.body);
  // print(getGendersResponse.body);
  Map getGendersMapResponse = json.decode(getGendersResponse.body);
  if(getGendersMapResponse['httpStatusCode'] == 200){
   List<dynamic> list = getGendersMapResponse["data"];
    BaseScreen.allGenders = Gender.listFromJson(list);
    // log('Genders ::: ' + BaseScreen.allGenders.toString());
  }
  else{
    BaseScreen.allGenders = List.empty();
  }
}

void getAllServiceTypes() async {
  var getAllServiceTypesResponse = await http.get(
    Uri.parse(swaggerApiUrl + "General/GetAllServices?LangId=" + SplashScreen.langId.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getAllServiceTypesResponse.body);
  // print(getAllServiceTypesResponse.body);
  Map getAllServiceTypesMapResponse = json.decode(getAllServiceTypesResponse.body);
  if(getAllServiceTypesMapResponse['httpStatusCode'] == 200){
   List<dynamic> list = getAllServiceTypesMapResponse["data"];
    BaseScreen.allServiceTypes = ServiceType.listFromJson(list);
    // log('Service Types ::: ' + BaseScreen.allGenders.toString());
  }
  else{
    BaseScreen.allServiceTypes = List.empty();
  }
}

Future<String> getPrivacyPolicy() async {
  String pp = '';
  var getPrivacyPolicyResponse = await http.get(
    Uri.parse(swaggerApiUrl + "General/GetAppDetailBasic"),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer " + LoginScreen.token
    },
  );
  // log(getPrivacyPolicyResponse.body);
  Map getPrivacyPolicyResponseMap = json.decode(getPrivacyPolicyResponse.body);
  if(getPrivacyPolicyResponseMap['httpStatusCode'] == 200){
     pp = getPrivacyPolicyResponseMap['data']['privacy_en'];
  }
  pp = htmlToText(pp);
  return pp;
}

void getLoyaltyPoints(String id) async {
  var response = await http.get(
    Uri.parse("https://testapi.esnadtakaful.com/api/LoyaltyProgram/GetHCPPointsGained?Id=" + id.toString()),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
    );
    Map res = json.decode(response.body);
    int points = res["data"];
    log('itsssssss loyaltyy');
    HomeScreen.loyaltyPoints = points;
  log(response.body);
  log(points.toString());
}