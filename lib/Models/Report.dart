class Report {
  final int? id;
  final String? name;

  Report({
    this.id, 
    this.name
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        id: json["id"],
        name: json["name"]
    );
  }

  static List<Report> listFromJson(list) {
    return List<Report>.from(list.map((x) {
      return Report.fromJson(x);
    }));
  }

}
