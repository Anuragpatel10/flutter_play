import 'package:flutter/material.dart';
import '../ui-elemnts/tab_bar.dart';
import '../pages/home/sub_tab_home.dart';
import '../models/page.dart';

List<Page> _allPages = <Page>[
  Page(icon: Icons.explore, text: 'For You', category: 'category-name'),
  Page(icon: Icons.insert_chart, text: 'Top Charts', category: 'category-name'),
  Page(icon: Icons.category, text: 'Categories', category: 'category-name'),
  Page(icon: Icons.stars, text: 'Editor\'s Choice', category: 'category-name'),
  Page(icon: Icons.wb_sunny, text: 'Family', category: 'category-name'),
  Page(
      icon: Icons.directions_bus,
      text: 'Early Access',
      category: 'category-name'),
];

class HomeTab extends StatefulWidget {
  HomeTab({this.scrollController, this.tabController});

  final ScrollController scrollController;
  final TabController tabController;

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  TabController _controller;

  Key _key = new PageStorageKey({});
  bool _innerListIsScrolled = false;

  void _updateScrollPosition() {
    if (!_innerListIsScrolled &&
        widget.scrollController.position.extentAfter == 0.0) {
      setState(() {
        _innerListIsScrolled = true;
      });
    } else if (_innerListIsScrolled &&
        widget.scrollController.position.extentAfter > 0.0) {
      setState(() {
        _innerListIsScrolled = false;
        // Reset scroll positions of the TabBarView pages
        _key = new PageStorageKey({});
      });
    }
  }

  @override
  void initState() {
    _controller = new TabController(vsync: this, length: _allPages.length);
    widget.scrollController.addListener(_updateScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateScrollPosition);
    super.dispose();
  }

  Widget build(BuildContext context) {
    final List<Widget> tabChildernPages = <Widget>[];
    _allPages.forEach((Page page) => tabChildernPages.add(HomeSubTab()));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TabBarWidget(_controller, _allPages),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: TabBarView(
              key: _key,
              controller: _controller,
              physics: new NeverScrollableScrollPhysics(),
              children: tabChildernPages,
            ),
          ),
        ),
      ],
    );
  }
}
