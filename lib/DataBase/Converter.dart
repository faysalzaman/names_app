// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:names_app/Model/names_model.dart';

class DataParser {
  DataParser({this.encodedJson});
  final String? encodedJson;

  /// Parses off the UI thread (an isolate on mobile, inline on web).
  Future<List<NameModel>> parseInBackground() {
    return compute(_decodeAndParseJson, encodedJson!);
  }
}

List<NameModel> _decodeAndParseJson(String encodedJson) {
  final jsonData = jsonDecode(encodedJson);
  final resultsJson = jsonData['result'] as List<dynamic>;
  return resultsJson.map((json) => NameModel.fromMap(json)).toList();
}
