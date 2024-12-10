import 'package:besure_hcp/Models/ClientReport.dart';

class DisplayReconcilation{
  int? id;
  List<ClientReport>? reportList;
  num? transactionTotalCenterCash, transactionBesurePayment, centerCashCommission, besureAmazonComission, totalAmount, transferFromBeSureToHCP, transferFromHCPToBeSure;

  DisplayReconcilation({
    this.id,
    this.reportList,
    this.besureAmazonComission,
    this.centerCashCommission,
    this.totalAmount,
    this.transactionBesurePayment,
    this.transactionTotalCenterCash,
    this.transferFromBeSureToHCP,
    this.transferFromHCPToBeSure
  });

  factory DisplayReconcilation.fromJson(Map<String, dynamic> json) {
    return DisplayReconcilation(
      reportList: ClientReport.listFromJson(json['clientCardReports']),
      besureAmazonComission: json['besureAmazonComission'],
      centerCashCommission: json['centerCashCommission'],
      totalAmount: json['totalAmount'],
      transactionBesurePayment: json['transactionBesurePayment'],
      transactionTotalCenterCash: json['transactionTotalCenterCash'],
      transferFromBeSureToHCP: json['transferFromBeSureToHCP'],
      transferFromHCPToBeSure: json['transferFromHCPToBeSure']
    );
  }
}