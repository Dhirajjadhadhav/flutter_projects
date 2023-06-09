//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Home",
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/analytics-icon.svg")),
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/search-icon.svg")),
              IconButton(
                  onPressed: () {}, icon: SvgPicture.asset("assets/more.svg")),
            ],
          )
        ],
      ),
    );
  }
}
