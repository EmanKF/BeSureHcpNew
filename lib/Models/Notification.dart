class Notification{
  final int? id;
  final String? description, date;

  Notification({
    this.id,
    this.description,
    this.date
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
        id: json["id"] ?? 0,
        description: json["description"] ?? '',
        date: json["date"] ?? ''
    );
  }

  static List<Notification> listFromJson(list) {
    return List<Notification>.from(list.map((x) {
      return Notification.fromJson(x);
    }));
  }

}