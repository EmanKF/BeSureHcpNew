class Client{
  final String? id, fullName, fullName_en, profile;

  Client({
    this.id, 
    this.fullName,
    this.fullName_en,
    this.profile
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
       id: json["id"],
       fullName: json['fullName'],
       fullName_en: json["fullName_en"],
       profile: json["profile"]
    );
  }

  static List<Client> listFromJson(list) {
    return List<Client>.from(list.map((x) {
      return Client.fromJson(x);
    }));
  }
}