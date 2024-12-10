class ServiceProvider{
  int? serviceProviderId, branchId, serviceProviderBranchesId, cityId;
  String? id, name, name_en, ownerName, ownerName_en, email, username, password, profile, phoneNumber, mobileNb, address, address_en, shortDescription, shortDescription_en, description, description_en, serviceProvideId,serviceProvideName_en,serviceProvideName;
  String? birthDate;
  String? deviceId = '';
  ServiceProvider({
    this.serviceProviderId,
    this.id,
    this.name,
    this.name_en,
    this.ownerName,
    this.ownerName_en,
    this.username,
    this.email,
    this.profile,
    this.phoneNumber,
    this.mobileNb,
    this.address,
    this.address_en,
    this.shortDescription,
    this.shortDescription_en,
    this.description,
    this.description_en,
    this.branchId,
    this.serviceProvideId,
    this.birthDate,
    this.deviceId,
    this.password,
    this.serviceProvideName,
    this.serviceProvideName_en,
    this.serviceProviderBranchesId,
    this.cityId
  });

  void updateServiceProvider(ServiceProvider sp){
    serviceProviderId = sp.serviceProviderId;
    id = sp.id;
    name = sp.name;
    ownerName = sp.ownerName;
    email = sp.email;
    username = sp.username;
    profile = sp.profile;
    phoneNumber = sp.profile;
    address = sp.address;
    shortDescription = sp.shortDescription;
    description = sp.description;
  }

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
        serviceProviderId: json["serviceProviderId"] ?? 0,
        serviceProvideId: json["serviceProvideId"] ?? '',
        id: json["id"] ?? 0,
        name: json["name"] ?? json["fullName"] ?? '',
        ownerName: json["ownerName"] ?? '',
        email: json["email"] ?? '',
        username: json["username"] ?? '',
        profile: json["profile"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        mobileNb:  json["mobileNb"] != null &&  json["mobileNb"] != '' &&  json["mobileNb"] != "string" ?  json["mobileNb"] :'',
        birthDate: json["birthDate"] ?? '',
        address: json["address"] ?? '',
        shortDescription: json["shortDescription"] ?? '',
        description: json["description"] ?? '',
        branchId: json['branchId'] ?? 0,
        serviceProviderBranchesId: json['serviceProviderBranchesId'],
        serviceProvideName: json['serviceProvideName'] ?? '',
        serviceProvideName_en: json['serviceProvideName_en'] ?? ''
    );
  }

  Map toMapInfo(ServiceProvider sp){
    Map map = new Map();
    map["profile"] = "string";
    map["phoneNumber2"] = "string";
    map["name"] = "string";
    map["name_en"] = "string";
    map["ownerName"] = "string";
    map["ownerName_en"] = "string";
    map["address"] = "string";
    map["address_en"] = "string";
    map["shortDescription"] = "string";
    map["description"] = "string";
    map["cityId"] = 0;
    map["long"] = 0;
    map["lat"] = 0;
    map["updated_by"] = 0;
    return map;
  }

  Map spRegister(ServiceProvider sp){
    Map map = new Map();
    map["id"] = "string";
    map["name"] = sp.name;
    map["name_en"] = sp.name_en;
    map["ownerName"] = sp.ownerName;
    map["ownerName_en"] = sp.ownerName_en;
    map["username"] = sp.username;
    map["email"] = sp.email;
    map["phoneNumber"] = sp.phoneNumber;
    map["password"] = sp.password;
    map["address"] = sp.address;
    map["address_en"] = sp.address_en;
    map["shortDescription"] = sp.shortDescription;
    map["shortDescription_en"] = sp.shortDescription_en;
    map["description"] = sp.description;
    map["description_en"] = sp.description_en;
    map["cityId"] = sp.cityId;
    print(map);
    return map;
  }

  static List<ServiceProvider> listFromJson(list) {
    return List<ServiceProvider>.from(list.map((x) {
      return ServiceProvider.fromJson(x);
    }));
  }

}