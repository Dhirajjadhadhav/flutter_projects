import 'package:banking_application/data/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constants/app_textstyle.dart';
import '../data/transaction_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: transaction.color,
                ),
                child: Image.asset(transaction.avatar),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.name,
                    style: ApptextStyle.LISTTILE_TITLE,
                  ),
                  Text(
                    transaction.month,
                    style: ApptextStyle.LISTTILE_SUBTITLE,
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.currrentBalance,
                    style: ApptextStyle.LISTTILE_TITLE,
                  ),
                  Row(
                    children: [
                      transaction.changePercentage == "up"
                          ? Icon(
                              FontAwesomeIcons.levelUpAlt,
                              size: 10,
                              color: Colors.green,
                            )
                          : Icon(
                              FontAwesomeIcons.levelDownAlt,
                              size: 10,
                              color: Colors.red,
                            ),
                      SizedBox(width: 5),
                      Text(
                        transaction.changePercentage,
                        style: ApptextStyle.LISTTILE_SUBTITLE,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
