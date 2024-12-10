import 'package:besure_hcp/Models/Client.dart';
import 'package:besure_hcp/Models/Service.dart';

class Appointment{
  final int? id, serviceProviderBranchId, clientPoints, paymentId, languageId;
  final String? serviceProviderUserId, serviceProviderId, clientId, orderNb, paymentDate, note, uploadedReciept, uploadedClientReciept, date, review;
  String? bookingDate;
  final num? amount, amountAfterDiscount, discount, discount_Benifit_PNPL, commision, uploadedAmount; 
  final bool? is_Paid_By_Amazon, is_Accepted, is_SPCLaimed, is_Cancel, is_Pending;
  final List<ServiceModel>? clientServices;
  final Client? client;


Appointment({
  this.id,
  this.amount,
  this.amountAfterDiscount,
  this.bookingDate,
  this.clientId,
  this.clientPoints,
  this.clientServices,
  this.commision,
  this.date,
  this.discount,
  this.discount_Benifit_PNPL,
  this.is_Accepted,
  this.is_Cancel,
  this.is_Paid_By_Amazon,
  this.is_Pending,
  this.is_SPCLaimed,
  this.languageId,
  this.note,
  this.orderNb,
  this.paymentDate,
  this.paymentId,
  this.review,
  this.serviceProviderBranchId,
  this.serviceProviderId,
  this.serviceProviderUserId,
  this.uploadedAmount,
  this.uploadedClientReciept,
  this.uploadedReciept,
  this.client
});

factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json["id"] ?? 0,
        amount: json["amount"] ?? 0,
        amountAfterDiscount: json["amountAfterDiscount"] ?? 0,
        bookingDate: json["bookingDate"] ?? '',
        clientId: json["clientId"] ?? '',
        clientPoints: json["clientPoints"] ?? '',
        clientServices: ServiceModel.listFromJsonAppointment(json["clientServices"]),
        commision: json["commision"] ?? 0,
        date: json["date"]?? '',
        discount: json["discount"] ?? 0,
        discount_Benifit_PNPL: json["discount_Benifit_PNPL"] ?? 0,
        is_Accepted: json["is_Accepted"],
        is_Cancel: json['is_Cancel'] ?? '',
        is_Paid_By_Amazon: json['is_Paid_By_Amazon'],
        is_Pending: json["is_Pending"],
        is_SPCLaimed: json["is_SPCLaimed"],
        languageId: json["languageId"] ?? 0,
        note: json["note"] ?? '',
        orderNb: json['orderNb'] ?? '',
        paymentDate: json['paymentDate'] ?? '',
        paymentId: json["paymentId"] ?? 0,
        review: json["review"] ?? '',
        serviceProviderBranchId: json["serviceProviderBranchId"],
        serviceProviderId: json['serviceProviderId'] ?? '',
        serviceProviderUserId: json['serviceProviderUserId'] ?? '',
        uploadedAmount: json["uploadedAmount"] ?? 0,
        uploadedClientReciept: json["uploadedClientReciept"] ?? '',
        uploadedReciept: json["uploadedReciept"] ?? '',
        client: Client.fromJson(json['client'])

    );
  }

  static List<Appointment> listFromJson(list) {
    return List<Appointment>.from(list.map((x) {
      return Appointment.fromJson(x);
    }));
  }

}