import 'package:besure_hcp/Models/ReportServiceDetail.dart';
import 'package:besure_hcp/Models/ReportTransactionDetails.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/Components/ServiceProvidedWidget.dart';

class ReportTransaction{
  String? branchName;
  List<ReportTransactionDetails>? tranactionDetail;
  int? tranactionCount;

  ReportTransaction({this.branchName, this.tranactionDetail, this.tranactionCount});

  ReportTransaction.fromJson(json) {
  branchName = json['branchName'];
  
  if (json['tranactionDetail'] != null) {
    tranactionDetail = <ReportTransactionDetails>[];
    
    // Ensure we are correctly iterating over the list
    json['tranactionDetail'].forEach((v) {
      tranactionDetail!.add(ReportTransactionDetails.fromJson(v));
    });
  }

  tranactionCount = json['tranactionCount'];
}

static List<ReportTransaction> listFromJson(list) {
    return List<ReportTransaction>.from(list.map((x) {
      return ReportTransaction.fromJson(x);
    }));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchName'] = this.branchName;
    if (this.tranactionDetail != null) {
      data['tranactionDetail'] =
          this.tranactionDetail!.map((v) => v.toJson()).toList();
    }
    data['tranactionCount'] = this.tranactionCount;
    return data;
  }

}