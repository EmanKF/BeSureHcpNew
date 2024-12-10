class Language {
  final int? id;
  final String? flag, name, languageCode;
  final bool? is_ltr;

  Language({
    this.id, 
    this.flag, 
    this.name, 
    this.languageCode,
    this.is_ltr
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
        id: json["id"],
        name: json["name"],
        languageCode: json["languageCode"],
        flag: json["flag"],
        is_ltr: json["is_ltr"]
    );
  }

  static List<Language> listFromJson(list) {
    return List<Language>.from(list.map((x) {
      return Language.fromJson(x);
    }));
  }

  // static List<Language> LanguageList() {
  //   return <Language>[
  //     Language(1, '🇺🇸', 'English', 'en'),
  //     Language(2, '🇸🇦', 'العربية', 'ar')
  //   ];
  // }
}
