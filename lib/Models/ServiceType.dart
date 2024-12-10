class ServiceType {
  final int? id, serviceId;
  final String? code, name, description, image;

  ServiceType({
    this.id, 
    this.serviceId,
    this.code,
    this.name,
    this.description,
    this.image
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
       id: json["id"] ?? 0,
       code: json['code'] ?? '',
       name: json['name'] ?? '',
       description: json['description'] ?? '',
       image: json['image'] ?? '',
       serviceId: json["serviceId"] ?? 0

    );
  }

  static List<ServiceType> listFromJson(list) {
    return List<ServiceType>.from(list.map((x) {
      return ServiceType.fromJson(x);
    }));
  }

}
