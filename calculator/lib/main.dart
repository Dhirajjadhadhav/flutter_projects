import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:math_expressions/math_expressions.dart';
import './colors.dart';

void main() {
  runApp(MaterialApp(
    home: CalculatorApp(),
  ));
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  //variables
  double firstNum = 0.0;
  double secondNum = 0.0;
  var input = '';
  var output = '';
  var operation = '';
  var hideInput = false;
  var outputSize = 34.0;

  OnButtonClick(value) {
    //if value is AC
    if (value == "AC") {
      input = '';
      output = '';
    } else if (value == "<") {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (value == "=") {
      if (input.isNotEmpty) {
        var userIput = input;
        userIput = input.replaceAll("X", "*");
        Parser p = Parser();
        Expression expression = p.parse(userIput);
        ContextModel cm = ContextModel();
        var finalValue = expression.evaluate(EvaluationType.REAL, cm);
        output = finalValue.toString();
        if (output.endsWith(".0")) {
          output = output.substring(0, output.length - 2);
        }
        input = output;
        hideInput = true;
        outputSize = 52;
      }
    } else {
      input = input + value;
      hideInput = false;
      outputSize = 34;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hideInput ? '' : input,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    output,
                    style: TextStyle(
                      fontSize: outputSize,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )),
            Row(
              children: [
                button(
                    text: "AC",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor),
                button(
                    text: "<",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor),
                button(text: "", buttonBgcolor: Colors.transparent),
                button(
                    text: "/",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor)
              ],
            ),
            Row(
              children: [
                button(text: "7"),
                button(text: "8"),
                button(text: "9"),
                button(
                    text: "X",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor),
              ],
            ),
            Row(
              children: [
                button(text: "4"),
                button(text: "5"),
                button(text: "6"),
                button(
                    text: "-",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor),
              ],
            ),
            Row(
              children: [
                button(text: "1"),
                button(text: "2"),
                button(text: "3"),
                button(
                    text: "+",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor),
              ],
            ),
            Row(
              children: [
                button(
                    text: "%",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor),
                button(text: "0"),
                button(
                    text: ".",
                    buttonBgcolor: operatorColor,
                    tcolor: orangeColor),
                button(text: "=", buttonBgcolor: orangeColor),
              ],
            )
          ],
        ));
  }

  Widget button({text, tcolor = Colors.white, buttonBgcolor = buttonColor}) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            primary: buttonBgcolor,
            padding: EdgeInsets.all(22)),
        onPressed: () => OnButtonClick(text),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 18, color: tcolor, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}
