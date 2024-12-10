class Transaction{
  final int? clientId, cardId;
  final String? id, fullName, fullName_en, profile;
  final bool? isUpload, is_deleted;

  Transaction({
    this.cardId,
    this.clientId,
    this.fullName,
    this.fullName_en,
    this.id,
    this.isUpload,
    this.is_deleted,
    this.profile
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],
      clientId: json['clientId'],
      cardId: json["cardId"],
      fullName: json["fullName"],
      fullName_en: json["fullName_en"],
      isUpload: json["isUpload"],
      profile: json["profile"] ?? '',
      is_deleted: json["is_deleted"]
    );
  }

  static List<Transaction> listFromJson(list) {
    return List<Transaction>.from(list.map((x) {
      return Transaction.fromJson(x);
    }));
  }
}