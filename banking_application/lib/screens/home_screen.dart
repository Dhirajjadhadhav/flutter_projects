import 'package:banking_application/constants/color_constants.dart';
import 'package:banking_application/data/card_data.dart';
import 'package:flutter/material.dart';
import '../constants/app_textstyle.dart';
import '../data/transaction_data.dart';
import '../widgets/my_card.dart';
import '../widgets/transaction_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bank App",
          style: TextStyle(
            fontFamily: "Poppins",
            color: kPrimaryColor,
          ),
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
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Mycard(
                        card: myCard[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: myCard.length),
              ),
              SizedBox(height: 30),
              Text(
                "Transaction details",
                style: ApptextStyle.BODY_TEXT,
              ),
              SizedBox(height: 15),
              ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TransactionCard(
                      transaction: myTransactions[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                  itemCount: myTransactions.length),
            ],
          ),
        ),
      ),
    );
  }
}
