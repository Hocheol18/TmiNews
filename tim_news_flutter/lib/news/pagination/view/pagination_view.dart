import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/news/pagination/class/IModelWithIdClass.dart';
import 'package:tim_news_flutter/news/pagination/controller/pagination_controller.dart';

import '../pagination_state.dart';
import '../provider/pagination_provider.dart';

typedef StorePaginationWidgetBuilder<T extends IModelWithId> = Widget Function(BuildContext, int index, T model);

class StorePaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationController, PaginationBase> provider;
  final StorePaginationWidgetBuilder<T> itemBuilder;
  final TabController tabController;
  const StorePaginationListView({
    required this.provider,
    required this.itemBuilder,
    required this.tabController,
    super.key,
});

  @override
  ConsumerState<StorePaginationListView> createState() => _StorePaginationListViewState<T>();

}

class _StorePaginationListViewState<T extends IModelWithId> extends ConsumerState<StorePaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // 위치 변경시 리패치
    ref.read(storePaginationController.notifier).locationBasePaginate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext contenxt) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final state = ref.watch(widget.provider);

    return CustomRefreshIndicator(
      onRefresh : () async
    )

  }

}