import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/view_model/provider.dart';
import 'package:test_app/view/widget/sliver_loading_list.dart';

class CharacterListWidget extends ConsumerStatefulWidget {
  const CharacterListWidget({super.key});

  @override
  ConsumerState<CharacterListWidget> createState() =>
      _CharacterListWidgetState();
}

class _CharacterListWidgetState extends ConsumerState<CharacterListWidget> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() async {
      final double maxScroll = controller.position.maxScrollExtent;
      final double currentScroll = controller.offset;
      if (maxScroll == currentScroll) {
        int page = ref.read(pageNumberProvider);
        page += 1;
        ref.watch(pageNumberProvider.notifier).change(page);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        controller: controller,
        slivers: [
          ref.watch(fullCharacterProvider).when(
              data: (list) => SliverList.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Text(list[index].name),
                        subtitle: Text(list[index].status),
                      )),
              error: (error, stackTrace) => SliverFillRemaining(
                    child: Center(
                      child: Text(error.toString()),
                    ),
                  ),
              loading: () => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )),
          const SliverLoadingList()
        ],
      ),
    );
  }
}
