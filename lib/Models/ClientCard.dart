import 'package:besure_hcp/Models/ClientService.dart';

class ClientCard{
  final int? id, serviceProviderBranchId, amount, discount;
  final String? serviceProviderUserId, clientId, uploadedReciept, uploadedClientReciept;
  final bool? is_Accepted, is_Cancel;
  final List<ClientService>? clientServices;

  ClientCard({
    this.id, 
    this.serviceProviderBranchId,
    this.amount,
    this.clientId,
    this.clientServices,
    this.discount,
    this.is_Accepted,
    this.is_Cancel,
    this.serviceProviderUserId,
    this.uploadedClientReciept,
    this.uploadedReciept,
  });

  factory ClientCard.fromJson(Map<String, dynamic> json) {
    return ClientCard(
      id: json["id"],
      amount: json["amount"],
      clientId: json["clientId"],
      clientServices: ClientService.listFromJson(json["clientServices"]),
      discount: json["discount"],
      is_Accepted: json["is_Accepted"],
      is_Cancel: json["is_Cancel"],
      serviceProviderBranchId: json["serviceProviderBranchId"],
      serviceProviderUserId: json["serviceProviderUserId"],
      uploadedClientReciept: json["uploadedClientReciept"],
      uploadedReciept: json["uploadedReciept"]
    );
  }

  static List<ClientCard> listFromJson(list) {
    return List<ClientCard>.from(list.map((x) {
      return ClientCard.fromJson(x);
    }));
  }
}