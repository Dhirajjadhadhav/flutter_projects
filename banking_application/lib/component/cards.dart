import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../utilities/themeStyle.dart';

class CardsList extends StatefulWidget {
  const CardsList({super.key});

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 32.0, left: 15.0, right: 15.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Cards",
                  style: ThemeStyle.primaryTitle,
                ),
                Text(
                  "See All",
                  style: ThemeStyle.SeeAll,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
