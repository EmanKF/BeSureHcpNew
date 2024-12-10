class CustomerReview {
  final int? id,clientCardId;
  final String? username, imageUrl, clientId, feedback;
  final int? ratingNb;
  CustomerReview({this.id, this.clientCardId, this.username, this.ratingNb, this.imageUrl, this.clientId, this.feedback});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
        id: json["id"],
        username: json["username"],
        clientId: json["clientId"],
        feedback: json["feedback"],
        ratingNb: json["ratingNb"],
        clientCardId: json["clientCardId"]
    );
  }

  static List<CustomerReview> listFromJson(list) {
    return List<CustomerReview>.from(list.map((x) {
      return CustomerReview.fromJson(x);
    }));
  }

}
