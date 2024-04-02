import 'dart:convert';
import 'dart:developer';

import 'package:pagination/model/data/character_model.dart';
import 'package:http/http.dart' as http;

class CharacterApi {
  CharacterApi._();
  factory CharacterApi() => _obj;
  static final CharacterApi _obj = CharacterApi._();
  final Uri uri =
      Uri(scheme: "https", host: "rickandmortyapi.com", path: "api/character");

  Future<List<Character>> getCharacterList(int page) async {
    List<Character> characterList = [];

    Uri uriWithPage = uri.replace(
        host: uri.host,
        path: uri.path,
        scheme: uri.scheme,
        queryParameters: {"page": page.toString()});

    final http.Response response = await http.get(uriWithPage);
    log(uriWithPage.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      for (var json in responseBody["results"]) {
        characterList.add(Character.fromJson(json));
      }
      return characterList;
    } else {
      throw (response.body);
    }
  }
}
