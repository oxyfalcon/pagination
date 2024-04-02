import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/view_model/provider.dart';

class SliverLoadingList extends ConsumerWidget {
  const SliverLoadingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int pageNumber = ref.watch(pageNumberProvider);
    return ref.watch(characterProvider(pageNumber)).when(
        data: (list) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => ref
              .watch(fullCharacterProvider.notifier)
              .appendCharacterList(list));
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
        error: (error, stackTrace) =>
            SliverToBoxAdapter(child: Center(child: Text(error.toString()))),
        loading: () => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ));
  }
}
