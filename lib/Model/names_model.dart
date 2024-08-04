// ignore_for_file: file_names

class NameModel {
  String? id;
  String? englishName;
  String? englishMeaning;
  String? englishReligion;
  String? englishLuckyDay;
  String? englishLuckyColor;
  String? englishLuckyStones;
  String? englishLanguage;
  String? englishLuckyMetals;
  String? englishFamousPerson;
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
  String? urduFamousPerson;

  NameModel({
    this.englishName,
    this.englishMeaning,
    this.englishReligion,
    this.englishLuckyDay,
    this.gender,
    this.englishLuckyColor,
    this.isFavourite,
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
    this.urduLuckyMetals,
    this.englishFamousPerson,
    this.urduFamousPerson,
  });

  factory NameModel.fromMap(json) {
    return NameModel(
      englishName: json['EnglishName'].toString(),
      englishMeaning: json['EnglishMeaning'].toString(),
      englishReligion: json['EnglishReligion'].toString(),
      gender: json["Gender"].toString(),
      englishLuckyDay: json['EnglishLuckyDay'].toString(),
      englishLuckyColor: json['EnglishLuckyColor'].toString(),
      englishLuckyStones: json['EnglishLuckyStones'].toString(),
      englishLanguage: json['EnglishLanguage'].toString(),
      englishLuckyMetals: json['EnglishLuckyMetals'].toString(),
      englishFamousPerson: json['EnglishFamousPerson'].toString(),
      urduName: json['UrduName'].toString(),
      urduMeaning: json['UrduMeaning'].toString(),
      urduReligion: json['UrduReligion'].toString(),
      urduLuckyNumber: json['UrduLuckyNumber'].toString(),
      urduLuckyDay: json['UrduLuckyDay'].toString(),
      urduLuckyColor: json['UrduLuckyColor'].toString(),
      urduLuckyStones: json['UrduLuckyStones'].toString(),
      urduLanguage: json['UrduLanguage'].toString(),
      urduLuckyMetals: json['UrduLuckyMetals'].toString(),
      urduFamousPerson: json['UrduFamousPerson'].toString(),
      // isFavourite: json['isFavourite'] is bool
      //     ? json['isFavourite']
      //     : json['isFavourite'] == 1
      //         ? true
      //         : false,
      isFavourite: json['isFavourite'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EnglishName'] = englishName;
    data['EnglishMeaning'] = englishMeaning;
    data['EnglishReligion'] = englishReligion;
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
    data['EnglishFamousPerson'] = englishFamousPerson;
    data['UrduFamousPerson'] = urduFamousPerson;
    return data;
  }
}
