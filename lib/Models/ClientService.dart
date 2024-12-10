class ClientService{
  final int? id, serviceProviderServicesId, clientCardId, amount;
  final double? discount;
  final String? serviceName, clientId, uploadedReciept, uploadedClientReciept, serviceImage;

  ClientService({
    this.id, 
    this.serviceProviderServicesId,
    this.amount,
    this.clientId,
    this.serviceName,
    this.discount,
    this.uploadedClientReciept,
    this.uploadedReciept,
    this.clientCardId,
    this.serviceImage
  });

  factory ClientService.fromJson(Map<String, dynamic> json) {
    return ClientService(
      id: json["id"],
      serviceProviderServicesId: json['serviceProviderServicesId'],
      amount: json["amount"] ?? 0,
      clientCardId: json["clientCardId"],
      clientId: json["clientId"],
      discount: json["discount"],
      serviceName: json["service"] ?? '',
      serviceImage: json["serviceImage"] ?? '',
      uploadedClientReciept: json["uploadedClientReciept"],
      uploadedReciept: json["uploadedReciept"]
    );
  }

  static List<ClientService> listFromJson(list) {
    return List<ClientService>.from(list.map((x) {
      return ClientService.fromJson(x);
    }));
  }
}