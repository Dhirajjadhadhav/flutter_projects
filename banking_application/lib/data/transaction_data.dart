import 'package:banking_application/constants/color_constants.dart';
import 'package:flutter/material.dart';

class TransactionModel {
  String name;
  String avatar;
  String currrentBalance;
  String month;
  String changePercentageIndicator;
  String changePercentage;
  Color? color;

  TransactionModel({
    this.name = "",
    this.avatar = "",
    this.currrentBalance = "",
    this.month = "",
    this.changePercentageIndicator = "",
    this.changePercentage = "",
    this.color = kThirdColor,
  });
}

List<TransactionModel> myTransactions = [
  TransactionModel(
    avatar: "assets/icons/avatar_1.png",
    currrentBalance: "\$8324",
    changePercentage: "0.21%",
    changePercentageIndicator: "up",
    name: "Ama serwa",
    month: "jan",
    color: Colors.green[100],
  ),
  TransactionModel(
    avatar: "assets/icons/avatar_2.png",
    currrentBalance: "\$4824",
    changePercentage: "0.21%",
    changePercentageIndicator: "Down",
    name: "kwane Ray ",
    month: "jan",
    color: Colors.green[100],
  ),
  TransactionModel(
    avatar: "assets/icons/avatar_3.png",
    currrentBalance: "\$9324",
    changePercentage: "0.43%",
    changePercentageIndicator: "up",
    name: "Grace serwa",
    month: "jan",
    color: Colors.green[100],
  ),
  TransactionModel(
    avatar: "assets/icons/avatar_4.png",
    currrentBalance: "\$1324",
    changePercentage: "0.21%",
    changePercentageIndicator: "Down",
    name: "kwame se",
    month: "jan",
    color: Colors.green[100],
  ),
];
