import 'package:flutter/material.dart';
import 'package:form_validation/screens/login_screen.dart';
import 'package:form_validation/widgets/searchbar.dart';
class AppbarRow extends StatefulWidget {
  const AppbarRow({super.key});

  @override
  _AppbarRowState createState() => _AppbarRowState();
}

class _AppbarRowState extends State<AppbarRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
            children: [
              Expanded(child: SizedBox(child: Searchbar())),
              SizedBox(width: 1), 
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
                icon: Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                ), 
              ),
            ],
          ),
    );
  }
}