// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:isolate';

import 'package:names_app/Model/names_model.dart';

class DataParser {
  DataParser({this.encodedJson});
  final String? encodedJson;
  // 2. public method that does the parsing in the background
  Future<List<NameModel>> parseInBackground() async {
    // create a port
    final p = ReceivePort();
    // spawn the isolate and wait for it to complete
    await Isolate.spawn(_decodeAndParseJson, p.sendPort);
    // get and return the result data
    return await p.first;
  }

  // 3. json parsing
  Future<void> _decodeAndParseJson(SendPort p) async {
    // decode and parse the json
    final jsonData = jsonDecode(encodedJson!);
    final resultsJson = jsonData['result'] as List<dynamic>;
    final results = resultsJson.map((json) => NameModel.fromMap(json)).toList();
    // return the result data via Isolate.exit()
    Isolate.exit(p, results);
  }
}
