class ServiceModel {
  final int? id, serviceProviderServicesId;
  int? price;
  final String? name, code, description, image, reason, note;
  final bool? is_Approved;
  bool? Is_Accepted = true;
  bool? isEligible = false;
  num? dis = 0;
      
  ServiceModel({this.name, this.id, this.code, this.dis, this.description, this.image, this.is_Approved, this.serviceProviderServicesId, this.note, this.price, this.reason, this.Is_Accepted});
  
  ServiceModel.ServiceModel(this.name, this.dis, this.id, this.price, this.description, this.code, this.image, this.isEligible, this.serviceProviderServicesId, this.is_Approved, this.note, this.reason, this.Is_Accepted);
  
  factory ServiceModel.clone(ServiceModel source){
    return ServiceModel.ServiceModel(source.name, source.dis, source.id, source.price, source.description, source.code, source.image, source.isEligible, source.serviceProviderServicesId, source.is_Approved, source.note, source.reason, source.Is_Accepted);
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        price: json["price"] ?? 0,
        description: json["description"] ?? '',
        code: json["code"] ?? '',
        image: json["image"] ?? '',
        reason: json["reason"] ?? '',
        note: json["note"] ?? '0.0',
        is_Approved: json["is_Approved"] ?? false,
        serviceProviderServicesId: json['serviceProviderServicesId'] ?? 0,
        Is_Accepted: true

    );
  }
  
  factory ServiceModel.fromJsonAppointment(Map<String, dynamic> json) {
    num discountRate = (json['discount'] * 100) / json["amount"];
    return ServiceModel(
        id: json["id"] ?? 0,
        name: json["service"] ?? '',
        price: json["amount"] ?? 0,
        description: json["description"] ?? '',
        code: json["code"] ?? '',
        dis: discountRate,
        image: json["serviceImage"] ?? '',
        serviceProviderServicesId: json['serviceProviderServicesId'] ?? 0,
        Is_Accepted: true

    );
  }

  static List<ServiceModel> listFromJson(list) {
    return List<ServiceModel>.from(list.map((x) {
      return ServiceModel.fromJson(x);
    }));
  }

  static List<ServiceModel> listFromJsonAppointment(list) {
    return List<ServiceModel>.from(list.map((x) {
      return ServiceModel.fromJsonAppointment(x);
    }));
  }
}
