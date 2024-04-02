import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/main.dart';
import 'package:http/http.dart' as http;

class CharacterNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Character>, int> {
  @override
  Future<List<Character>> build(int arg) async =>
      await CharacterApi().getCharacterList(arg);

  Future<List<Character>> getNextPage(int pageNumber) async =>
      await CharacterApi().getCharacterList(pageNumber);
}

final AutoDisposeAsyncNotifierProviderFamily<CharacterNotifier, List<Character>,
        int> characterProvider =
    AutoDisposeAsyncNotifierProviderFamily<CharacterNotifier, List<Character>,
        int>(() => CharacterNotifier());

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
