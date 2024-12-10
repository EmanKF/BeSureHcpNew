import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Models/ReportTransactionDetails.dart';
import 'package:besure_hcp/Models/ReportServiceDetail.dart';
import 'package:besure_hcp/Models/ReportTransaction.dart';
import 'package:http/http.dart' as http;
import 'package:besure_hcp/Constants/constantUrls.dart';

Future<List<ReportTransaction>> getSPReportNew(Map map) async{
  List<ReportTransaction> report;
  var getSPReportResponse = await http.post(
    Uri.parse(swaggerApiUrl + "Report/GetSPReport"),
    body: json.encode(map),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  Map getSPReportMapResponse = json.decode(getSPReportResponse.body);
    log(getSPReportMapResponse.toString());

  if(getSPReportMapResponse['httpStatusCode'] == 200 ){
//     log(getSPReportMapResponse['branchName']); // Debugging branchName
// log(getSPReportMapResponse['tranactionDetail']); // Debugging tranactionDetail
    report = ReportTransaction.listFromJson(getSPReportMapResponse["data"]);
    // log(report.branchName.toString());
    // log(report.tranactionCount.toString());
    // log('-----------------');
    // for(ReportTransactionDetails r in report.tranactionDetail!){
    //   log(r.employeeName.toString());
    //   log(r.servicesCount.toString());
    //   for(ReportServicesDetail s in r.servicesDetail!){
    //   log(s.service.toString());
    //   log(s.amount.toString());
    //   log(s.discount.toString());
    //   }
    //   log('==============');
    //  }
  }
  else{
    report = List.empty();
  }
  return report;
}

Future<bool> getSPGenderReport(Map map) async{
  var getSPReportResponse = await http.post(
    Uri.parse(swaggerApiUrl + "Report/GetSPGenderReport"),
    body: json.encode(map),
     headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    // "Authorization": "Bearer " + LoginScreen.token
    },
  );
  print(getSPReportResponse.body);
  Map getSPReportMapResponse = json.decode(getSPReportResponse.body);
  if(getSPReportMapResponse['httpStatusCode'] == 200){
    return true;
  }
  else{
    return false;
  }
}