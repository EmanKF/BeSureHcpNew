class ReportServicesDetail {
  String? service;
  num? discount;
  String? date;
  num? amount;

  ReportServicesDetail({this.service, this.discount, this.date, this.amount});

  ReportServicesDetail.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    discount = json['discount'];
    date = json['date'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service'] = this.service;
    data['discount'] = this.discount;
    data['date'] = this.date;
    data['amount'] = this.amount;
    return data;
  }
}