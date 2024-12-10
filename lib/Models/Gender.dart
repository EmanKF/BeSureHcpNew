class Gender {
  final int? id;
  final String? code;

  Gender({
    this.id, 
    this.code
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
        id: json["id"],
       code: json['code']
    );
  }

  static List<Gender> listFromJson(list) {
    return List<Gender>.from(list.map((x) {
      return Gender.fromJson(x);
    }));
  }

}
