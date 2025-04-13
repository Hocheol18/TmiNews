import 'package:flutter/material.dart';

class TopNavigator extends StatefulWidget {
  // 위에 들어올 카테고리 목록
  final List<String> tabTitles;

  // 탭 변경 콜백
  final Function(int) onTabChanged;

  // 현재 인덱스
  final int tabIndex;

  const TopNavigator({
    super.key,
    required this.tabTitles,
    required this.onTabChanged,
    required this.tabIndex,
  });

  @override
  State<TopNavigator> createState() => _TopNavigatorState();
}

class _TopNavigatorState extends State<TopNavigator>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabTitles.length,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index);
      }
    });
  }

  // 닫힐 때
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      TabBar(
      controller: _tabController,
      isScrollable: false,
      labelColor: Colors.red,
      unselectedLabelColor: Colors.black,
      tabs:
          widget.tabTitles
              .map(
                (title) => Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                  ),
                ),
              )
              .toList(),
    );
  }

  TabController get tabController => _tabController;
}
