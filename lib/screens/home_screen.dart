import 'package:flutter/material.dart';
import 'package:form_validation/screens/fragment_screens/home_tab.dart';
import 'package:form_validation/screens/fragment_screens/join_tab.dart';
import 'package:form_validation/screens/fragment_screens/order_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomeTab(),
    JoinTab(),
    OrderTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main body content
      body: Stack(
        children: [
          _pages[_selectedIndex],

          Positioned(
            bottom: 14,
            left: 20,
            right: 20,
            child: PhysicalModel(
              elevation: 8,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.deepOrangeAccent,
                  unselectedItemColor: Colors.grey,
                  onTap: _onItemTapped,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business_center),
                      label: 'Join Us',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag),
                      label: 'Orders',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
