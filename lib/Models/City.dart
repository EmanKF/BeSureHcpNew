class City {
  final int? id;
  final String? code;

  City({
    this.id, 
    this.code
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        id: json["id"],
       code: json['code']
    );
  }

  static List<City> listFromJson(list) {
    return List<City>.from(list.map((x) {
      return City.fromJson(x);
    }));
  }

}
