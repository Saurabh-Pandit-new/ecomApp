import 'package:flutter/material.dart';
import 'package:form_validation/screens/fragment_screens/tab_screens/Categories_tab.dart';
import 'package:form_validation/screens/fragment_screens/tab_screens/exploreNow_tab.dart';
import 'package:form_validation/screens/fragment_screens/tab_screens/gifts_tab.dart';
import 'package:form_validation/screens/fragment_screens/tab_screens/toprated_tab.dart';
import 'tab_screens/trending_tab.dart';
import 'tab_screens/new_arrivals_tab.dart';
import 'tab_screens/hot_deals_tab.dart';
import 'tab_screens/premium_tab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = [
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.explore, size: 21,),
        SizedBox(height: 1),
        Text('Explore Now', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.category, size: 21,),
        SizedBox(height: 1),
        Text('Categories', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.trending_up, size: 21,),
        SizedBox(height: 1),
        Text('Trending', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.fiber_new, size: 21,),
        SizedBox(height: 1),
        Text('New Arrivals', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.local_fire_department, size: 21,),
        SizedBox(height: 1),
        Text('Hot Deals', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star, size: 21),
        SizedBox(height: 1),
        Text('Premium Picks', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.thumb_up, size: 21,),
        SizedBox(height: 1),
        Text('Top Rated', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.card_giftcard, size: 21,),
        SizedBox(height: 1),
        Text('Gifts & Combos', style: TextStyle(fontSize: 10)),
      ],
    ),
  ),
];


  final List<Widget> myTabViews =  [
    ExplorenowTab(),
    CategoriesTab(),
    TrendingTab(),
    NewArrivalsTab(),
    HotDealsTab(),
    PremiumTab(),
    TopratedTab(),
    GiftsTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.deepOrangeAccent,
            unselectedLabelColor: Colors.black.withOpacity(0.4),
            indicatorColor: Colors.deepOrangeAccent,
            indicatorWeight: 1, // thinner line
            labelPadding: EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 1.0,
            ), // reduce spacing
            tabs: myTabs,
          ),

          Expanded(
            child: TabBarView(controller: _tabController, children: myTabViews),
          ),
        ],
      ),
    );
  }
}
