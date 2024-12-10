import 'package:besure_hcp/Models/ReportServiceDetail.dart';

class ReportTransactionDetails {
  List<ReportServicesDetail>? servicesDetail;
  String? date;
  String? employeeName;
  int? servicesCount;

  ReportTransactionDetails(
      {this.servicesDetail, this.date, this.employeeName, this.servicesCount});

  ReportTransactionDetails.fromJson(Map<String, dynamic> json) {
    if (json['servicesDetail'] != null) {
      servicesDetail = <ReportServicesDetail>[];
      json['servicesDetail'].forEach((v) {
        servicesDetail!.add(new ReportServicesDetail.fromJson(v));
      });
    }
    date = json['date'];
    employeeName = json['employeeName'];
    servicesCount = json['servicesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.servicesDetail != null) {
      data['servicesDetail'] =
          this.servicesDetail!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['employeeName'] = this.employeeName;
    data['servicesCount'] = this.servicesCount;
    return data;
  }
}
