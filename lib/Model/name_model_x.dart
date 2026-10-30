import 'package:names_app/Model/names_model.dart';

/// Presentation helpers shared by every screen that shows a [NameModel].
extension NameModelX on NameModel {
  /// The datasets label boys as Male / Boy / Larka.
  bool get isMale =>
      gender == 'Male' || gender == 'Boy' || gender == 'Larka';

  bool get isFav => isFavourite == '1' || isFavourite == 'true';

  String get initial {
    final n = englishName?.trim() ?? '';
    return n.isEmpty ? '?' : n[0].toUpperCase();
  }

  String get displayName => clean(englishName) ?? '';
  String? get meaning => clean(englishMeaning);
  String? get urdu => clean(urduName);

  /// Datasets serialise missing values as the string 'null'.
  static String? clean(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty || v == 'null') return null;
    return v;
  }
}
