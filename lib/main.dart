import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(body: ProviderScope(child: TestWidget()))));
  }
}

class TestWidget extends ConsumerStatefulWidget {
  const TestWidget({super.key});

  @override
  ConsumerState<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends ConsumerState<TestWidget> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() async {
      final double maxScroll = controller.position.maxScrollExtent;
      final double currentScroll = controller.offset;
      if (maxScroll == currentScroll) {
        int page = ref.read(pageNumberProvider);
        // log("i am here");
        page += 1;
        ref.read(pageNumberProvider.notifier).change(page);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        ref.watch(fullCharacterProvider).when(
            data: (list) => SliverList.builder(
                itemCount: list.length,
                itemBuilder: (context, index) => ListTile(
                      title: Text(list[index].name),
                      subtitle: Text(list[index].status),
                    )),
            error: (error, stackTrace) => SliverToBoxAdapter(
                  child: Center(
                    child: Text(error.toString()),
                  ),
                ),
            loading: () => const SliverToBoxAdapter(
                    child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ))),
        const SliverLoadingList()
      ],
    );
  }
}

class Character {
  final int id;
  final String name;
  final String status;

  Character({required this.id, required this.name, required this.status});

  factory Character.fromJson(Map<String, dynamic> json) =>
      Character(id: json["id"], name: json["name"], status: json["status"]);
}

class SliverLoadingList extends ConsumerWidget {
  const SliverLoadingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(characterProvider(ref.watch(pageNumberProvider))).when(
        data: (list) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (ref.watch(pageNumberProvider) > 1) {
              ref
                  .watch(fullCharacterProvider.notifier)
                  .appendCharacterList(list);
            }
          });
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
