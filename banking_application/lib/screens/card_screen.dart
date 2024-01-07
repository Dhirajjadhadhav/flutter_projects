import 'package:banking_application/constants/color_constants.dart';
import 'package:banking_application/data/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constants/app_textstyle.dart';
import '../data/transaction_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/my_card.dart';
import '../widgets/transaction_card.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My card",
          style: TextStyle(fontFamily: "Poppins", color: kPrimaryColor),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 16,
            child: ClipRRect(
                child: Image.asset("assets/icons/avatar_4.jpg"),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_active_outlined,
              color: Colors.black,
              size: 27,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Mycard(card: myCard[index]);
                  },
                  separatorBuilder: (contex, index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: myCard.length),
            ),
            CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
            Text(
              "Add card",
              style: ApptextStyle.LISTTILE_TITLE,
            ),
          ],
        ),
      ),
    );
  }
}
