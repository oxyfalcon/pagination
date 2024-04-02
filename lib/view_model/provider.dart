import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/model/character_model.dart';

final characterProvider =
    FutureProviderFamily<List<Character>, int>((ref, arg) async {
  if (arg == 1) {
    return <Character>[];
  } else {
    return await CharacterApi().getCharacterList(arg);
  }
});

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
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      for (var json in responseBody["results"]) {
        characterList.add(Character.fromJson(json));
      }
      return characterList;
    } else {
      throw ("Error");
    }
  }
}

class FullCharacterNotifier extends AutoDisposeAsyncNotifier<List<Character>> {
  @override
  Future<List<Character>> build() async {
    return await CharacterApi().getCharacterList(1);
  }

  void appendCharacterList(List<Character> characterList) {
    if (state.hasValue) {
      state = AsyncValue.data([...state.value!, ...characterList]);
    }
  }
}

final AutoDisposeAsyncNotifierProvider<FullCharacterNotifier, List<Character>>
    fullCharacterProvider =
    AutoDisposeAsyncNotifierProvider<FullCharacterNotifier, List<Character>>(
        () => FullCharacterNotifier());

class PageNumberNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() => 1;

  void change(int pageNumber) => state = pageNumber;
}

final AutoDisposeNotifierProvider<PageNumberNotifier, int> pageNumberProvider =
    AutoDisposeNotifierProvider<PageNumberNotifier, int>(
        () => PageNumberNotifier());
