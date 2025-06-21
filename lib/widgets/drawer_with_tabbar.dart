import 'package:flutter/material.dart';
import 'package:form_validation/widgets/blinking_tab.dart';
import 'tab_screens/orders_tab.dart';
import 'tab_screens/categories_tab.dart';
import 'tab_screens/wishlist_tab.dart';
import 'tab_screens/settings_tab.dart';

class TopTabScreen extends StatefulWidget {
  const TopTabScreen({super.key});

  @override
  State<TopTabScreen> createState() => _TopTabScreenState();
}

class _TopTabScreenState extends State<TopTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _blinkController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();
    _blinkController.dispose();
    super.dispose();
  }



  // @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.orangeAccent,
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              indicatorColor: Colors.orangeAccent,
              tabs: [
                const Tab(icon: Icon(Icons.trending_up), text: 'Trending'),
                const Tab(icon: Icon(Icons.fiber_new), text: 'New Arrivals'),
                const Tab(icon: Icon(Icons.local_fire_department), text: 'Hot Deals'),
                const Tab(icon: Icon(Icons.star), text: 'Premium Picks'),
              ],
            ),
          ),
          // 🔽 TabBarView Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                OrdersTab(),
                CategoriesTab(),
                WishlistTab(),
                SettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
