import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/bottomNavigator.dart';
import '../mypage/myPage.dart';
import '../news/news_main.dart';

final selectedTabProvider = StateProvider<int>((ref) => 1);

class MainContainer extends ConsumerWidget {
  MainContainer({super.key});

  final List<Widget> _pages = [SizedBox.shrink(), NewsMainPage(), MypageMain()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      body: IndexedStack(index: selectedTab, children: _pages),
      bottomNavigationBar: BottomNavigator(
        currentIndex: selectedTab,
        onTap: (index) {
          if (index == 0) {
            print("dd");
            Navigator.pushReplacementNamed(context, '/create');
            return;
          }
          ref.read(selectedTabProvider.notifier).state = index;
        },
      ),
    );
  }
}
