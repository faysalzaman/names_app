// ignore_for_file: file_names

class NameModel {
  String? id;
  String? englishName;
  String? englishMeaning;
  String? englishReligion;
  String? englishLuckyNumber;
  String? englishLuckyDay;
  String? englishLuckyColor;
  String? englishLuckyStones;
  String? englishLanguage;
  String? englishLuckyMetals;
  String? urduName;
  String? urduMeaning;
  String? urduReligion;
  String? urduLuckyNumber;
  String? urduLuckyDay;
  String? urduLuckyColor;
  String? urduLuckyStones;
  String? urduLanguage;
  String? urduLuckyMetals;
  String? isFavourite;
  String? gender;

  NameModel(
      {this.englishName,
      this.englishMeaning,
      this.englishReligion,
      this.englishLuckyNumber,
      this.englishLuckyDay,
      this.gender,
      this.englishLuckyColor,
      this.isFavourite = "false",
      this.englishLuckyStones,
      this.englishLanguage,
      this.englishLuckyMetals,
      this.id,
      this.urduName,
      this.urduMeaning,
      this.urduReligion,
      this.urduLuckyNumber,
      this.urduLuckyDay,
      this.urduLuckyColor,
      this.urduLuckyStones,
      this.urduLanguage,
      this.urduLuckyMetals});

  factory NameModel.fromMap(json) {
    return NameModel(
      englishName: json['EnglishName'],
      englishMeaning: json['EnglishMeaning'],
      englishReligion: json['EnglishReligion'],
      gender: json["Gender"],
      englishLuckyNumber: json['EnglishLuckyNumber'],
      englishLuckyDay: json['EnglishLuckyDay'],
      englishLuckyColor: json['EnglishLuckyColor'],
      englishLuckyStones: json['EnglishLuckyStones'],
      englishLanguage: json['EnglishLanguage'],
      englishLuckyMetals: json['EnglishLuckyMetals'],
      urduName: json['UrduName'],
      urduMeaning: json['UrduMeaning'],
      urduReligion: json['UrduReligion'],
      urduLuckyNumber: json['UrduLuckyNumber'],
      urduLuckyDay: json['UrduLuckyDay'],
      urduLuckyColor: json['UrduLuckyColor'],
      urduLuckyStones: json['UrduLuckyStones'],
      urduLanguage: json['UrduLanguage'],
      urduLuckyMetals: json['UrduLuckyMetals'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EnglishName'] = englishName;
    data['EnglishMeaning'] = englishMeaning;
    data['EnglishReligion'] = englishReligion;
    data['EnglishLuckyNumber'] = englishLuckyNumber;
    data['EnglishLuckyDay'] = englishLuckyDay;
    data['Gender'] = gender;
    data['EnglishLuckyColor'] = englishLuckyColor;
    data['EnglishLuckyStones'] = englishLuckyStones;
    data['isFavourite'] = isFavourite;
    data['EnglishLanguage'] = englishLanguage;
    data['EnglishLuckyMetals'] = englishLuckyMetals;
    data['UrduName'] = urduName;
    data['UrduMeaning'] = urduMeaning;
    data['UrduReligion'] = urduReligion;
    data['UrduLuckyNumber'] = urduLuckyNumber;
    data['UrduLuckyDay'] = urduLuckyDay;
    data['UrduLuckyColor'] = urduLuckyColor;
    data['UrduLuckyStones'] = urduLuckyStones;
    data['UrduLanguage'] = urduLanguage;
    data['UrduLuckyMetals'] = urduLuckyMetals;
    return data;
  }
}
