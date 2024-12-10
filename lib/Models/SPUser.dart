// class SPUser{
//   int? SPUserId;
//   String? id, name, ownerName, email, username, profile, phoneNumber, address, shortDescription, description;

//   SPUser({
//     this.SPUserId,
//     this.id,
//     this.name,
//     this.ownerName,
//     this.email,
//     this.username,
//     this.profile,
//     this.phoneNumber,
//     this.address,
//     this.shortDescription,
//     this.description
//   });

//   void updateServiceProvider(SPUser sp){
//     SPUserId = sp.SPUserId;
//     id = sp.id;
//     name = sp.name;
//     ownerName = sp.ownerName;
//     email = sp.email;
//     username = sp.username;
//     profile = sp.profile;
//     phoneNumber = sp.profile;
//     address = sp.address;
//     shortDescription = sp.shortDescription;
//     description = sp.description;
//   }

//   factory SPUser.fromJson(Map<String, dynamic> json) {
//     return SPUser(
//         SPUserId: json["serviceProviderId"],
//         id: json["id"] ?? 0,
//         name: json["name"] ?? '',
//         ownerName: json["ownerName"] ?? '',
//         email: json["email"] ?? '',
//         username: json["username"] ?? '',
//         profile: json["profile"] ?? '',
//         phoneNumber: json["phoneNumber"] ?? '',
//         address: json["address"] ?? '',
//         shortDescription: json["shortDescription"] ?? '',
//         description: json["description"] ?? '',
//     );
//   }

//   Map toMapInfo(SPUser sp){
//     Map map = new Map();
//     map["profile"] = "string";
//     map["phoneNumber2"] = "string";
//     map["name"] = "string";
//     map["name_en"] = "string";
//     map["ownerName"] = "string";
//     map["ownerName_en"] = "string";
//     map["address"] = "string";
//     map["address_en"] = "string";
//     map["shortDescription"] = "string";
//     map["description"] = "string";
//     map["cityId"] = 0;
//     map["long"] = 0;
//     map["lat"] = 0;
//     map["updated_by"] = 0;
//     return map;
//   }

//   static List<SPUser> listFromJson(list) {
//     return List<SPUser>.from(list.map((x) {
//       return SPUser.fromJson(x);
//     }));
//   }

// }