import 'package:flutter/material.dart';
import 'package:form_validation/controller/user_controller.dart';
import 'package:form_validation/screens/cart_page.dart';
import 'package:form_validation/screens/home_screen.dart';
import 'package:form_validation/screens/login_screen.dart';
import 'package:form_validation/widgets/my_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController _userController=Get.put(UserController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.deepOrange,Colors.amber,Colors.deepOrangeAccent,Colors.yellowAccent]),
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Welcome to '
                              'Trendora',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Obx(()=>
                      _userController.isLogin.value?
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ):IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                        },
                      ),),
                      const SizedBox(width: 4),
                      // Search Bar
                      Expanded(
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search here...',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(()=>
                        _userController.isLogin.value?
                        IconButton(
                          icon: Icon(Icons.shopping_cart, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CartPage()),
                            );
                          },
                        ):IconButton(
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            
            const Expanded(child: HomeScreen()),
          ],
        ),
      ),
    );
  }
}
