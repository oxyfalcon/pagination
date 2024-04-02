import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pagination/model/api/character_api.dart';
import 'package:pagination/model/data/character_model.dart';

final characterProvider =
    FutureProviderFamily<List<Character>, int>((ref, arg) async {
  if (arg == 1) {
    return <Character>[];
  } else {
    return await CharacterApi().getCharacterList(arg);
  }
});

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
