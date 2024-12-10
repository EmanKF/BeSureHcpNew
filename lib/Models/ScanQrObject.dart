class ScanQrObject {
  final String? clientId;
  final String? name;
  final int? discount;

  ScanQrObject({
    this.clientId, 
    this.name,
    this.discount
  });

  factory ScanQrObject.fromJson(Map<String, dynamic> json) {
    return ScanQrObject(
      clientId: json["clientId"],
      name: json['name'],
      discount: json['discount']
    );
  }
}
