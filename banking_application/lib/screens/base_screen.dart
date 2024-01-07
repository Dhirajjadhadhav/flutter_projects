import 'package:banking_application/constants/color_constants.dart';
import 'package:banking_application/data/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constants/app_textstyle.dart';
import '../data/transaction_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/my_card.dart';
import '../widgets/transaction_card.dart';
import './home_screen.dart';
import './card_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CardScreen(),
    HomeScreen(),
    CardScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.creditCard), label: "Cards"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.cog), label: "Settings"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartBar), label: "Overview")
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
