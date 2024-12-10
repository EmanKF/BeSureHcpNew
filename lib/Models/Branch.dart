class Branch{
  final int? id, cityId, languageId, serviceProviderBranchesId;
  final double? long, lat;
  final String? name, image, description, mobile, address, serviceProviderId, speciality, websiteUrl;
  final bool? is_Approved, is_deleted;

  Branch({
    this.id,
    this.name,
    this.image,
    this.description,
    this.mobile,
    this.address,
    this.cityId,
    this.languageId,
    this.serviceProviderId,
    this.serviceProviderBranchesId,
    this.speciality,
    this.websiteUrl,
    this.long,
    this.lat,
    this.is_Approved,
    this.is_deleted
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        description: json["description"] ?? '',
        mobile: json["mobile"] ?? '',
        address: json["address"] ?? '',
        languageId: json["languageId"] ?? 0,
        long: json["long"].toDouble() ?? 0.0,
        lat: json["lat"].toDouble() ?? 0.0,
        is_Approved: json["is_Approved"] ?? false,
        is_deleted: json["is_deleted"] ?? false,
        serviceProviderBranchesId: json["serviceProviderBranchesId"],
        speciality: json['speciality'] ?? '',
        websiteUrl: json['websitUrl'] ?? ''
    );
  }

  static List<Branch> listFromJson(list) {
    return List<Branch>.from(list.map((x) {
      return Branch.fromJson(x);
    }));
  }

}