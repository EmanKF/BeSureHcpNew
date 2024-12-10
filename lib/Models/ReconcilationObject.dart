class ReconcilationObject{
  int? id;
  String? serviceProviderId, reconcilationFrom, reconcilationTo, transferDate, date, userId,transferNo, fileName;
  num? besureSetteledAmount, spSetteledAmount, discount_Benifit_PNPL, beSureCommision; 
  bool? is_Pending, is_Settled_Besure, is_Settled_SP, is_deleted, is_Canceled;

  ReconcilationObject({
    this.id,
    this.beSureCommision,
    this.besureSetteledAmount,
    this.date,
    this.discount_Benifit_PNPL,
    this.is_Pending,
    this.is_Settled_Besure,
    this.is_Settled_SP,
    this.is_deleted,
    this.reconcilationFrom,
    this.reconcilationTo,
    this.serviceProviderId,
    this.spSetteledAmount,
    this.transferDate,
    this.transferNo,
    this.userId,
    this.fileName,
    this.is_Canceled
  });

  factory ReconcilationObject.fromJson(Map<String, dynamic> json) {
    return ReconcilationObject(
      id: json['id'],
      beSureCommision: json['beSureCommision'],
      besureSetteledAmount: json['besureSetteledAmount'],
      date: json['date'],
      discount_Benifit_PNPL: json['discount_Benifit_PNPL'],
      is_Pending: json['is_Pending'],
      is_Settled_Besure: json['is_Settled_Besure'],
      is_Settled_SP: json['is_Settled_SP'],
      is_deleted: json['is_deleted'],
      reconcilationFrom: json['reconcilationFrom'],
      reconcilationTo: json['reconcilationTo'],
      serviceProviderId: json['serviceProviderId'],
      spSetteledAmount: json['spSetteledAmount'],
      transferDate: json['transferDate'],
      transferNo: json['transferNo'],
      userId: json['userId'],
      fileName: json['fileName'],
      is_Canceled: json['is_Canceled']
    );
  }

  static List<ReconcilationObject> listFromJson(list) {
    return List<ReconcilationObject>.from(list.map((x) {
      return ReconcilationObject.fromJson(x);
    }));
  }

}
