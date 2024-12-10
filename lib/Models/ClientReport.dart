class ClientReport{
  final int? id, serviceProviderBranchId, paymentId;
  final num? amount, centerAmount, discount, discount_Benifit_PNPL, commision, uploadedAmount;
  final String? serviceProviderUserId, serviceProviderId, serviceProviderBranchName, clientId, clientName, orderNb, note, uploadedReciept, uploadedClientReciept, paymentDate;
  final bool? is_Paid_By_Amazon, is_Accepted, is_SPCLaimed, is_Cancel, is_deleted; 

  ClientReport({
    this.id,
    this.serviceProviderBranchId,
    this.serviceProviderBranchName,
    this.paymentId,
    this.amount,
    this.centerAmount,
    this.discount,
    this.discount_Benifit_PNPL,
    this.commision,
    this.uploadedAmount,
    this.serviceProviderId,
    this.serviceProviderUserId,
    this.clientId,
    this.clientName,
    this.orderNb,
    this.note,
    this.uploadedClientReciept,
    this.uploadedReciept,
    this.is_Accepted,
    this.is_Cancel,
    this.is_Paid_By_Amazon,
    this.is_SPCLaimed,
    this.is_deleted,
    this.paymentDate
  });

  factory ClientReport.fromJson(Map<String, dynamic> json) {
    return ClientReport(
        id: json["id"] ?? 0,
        serviceProviderBranchId: json["serviceProviderBranchId"] ?? 0,
        serviceProviderBranchName: json["serviceProviderBranchName"] ?? '',
        paymentId: json["paymentId"] ?? 0,
        amount: json["amount"] ?? 0,
        centerAmount: json["centerAmount"] ?? 0,
        discount: json["discount"] ?? 0,
        discount_Benifit_PNPL: json["discount_Benifit_PNPL"] ?? 0,
        commision: json["commision"] ?? 0,
        uploadedAmount: json["uploadedAmount"] ?? 0,
        serviceProviderId: json["serviceProviderId"] ?? '',
        serviceProviderUserId: json["serviceProviderUserId"] ?? '',
        clientId: json['clientId'] ?? '',
        clientName: json['clientName'] ?? '',
        orderNb: json["orderNb"] ?? '',
        note: json["note"] ?? '',
        uploadedClientReciept: json["uploadedClientReciept"] ?? '',
        uploadedReciept: json['uploadedReciept'] ?? '',
        is_Accepted: json['is_Accepted'],
        is_Cancel: json["is_Cancel"],
        is_Paid_By_Amazon: json["is_Paid_By_Amazon"],
        is_SPCLaimed: json["is_SPCLaimed"],
        is_deleted: json['is_deleted'] ?? '',
        paymentDate: json['created_at'] ?? ''
    );
  }

  static List<ClientReport> listFromJson(list) {
    return List<ClientReport>.from(list.map((x) {
      return ClientReport.fromJson(x);
    }));
  }

}