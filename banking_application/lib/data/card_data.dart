import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

class CardModel {
  String? cardHolderName;
  String? cardNumber;
  String? exDate;
  String? cvv;
  Color? cardColor;

  CardModel(
      {this.cardHolderName,
      this.cardNumber,
      this.cardColor,
      this.cvv,
      this.exDate});
}

List<CardModel> myCard = [
  CardModel(
      cardHolderName: "Kofi kinata",
      cardNumber: "**** **** **** 1234",
      cardColor: kbBackgroundColor,
      cvv: "**4",
      exDate: "12/24"),
  CardModel(
      cardHolderName: "Ama Serwa",
      cardNumber: "**** **** **** 2341",
      cardColor: kSecondaryColor,
      cvv: "**3",
      exDate: "12/25"),
];
