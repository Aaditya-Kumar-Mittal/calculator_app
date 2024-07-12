import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userInput = "";
  String result = "0";
  List<String> buttonList = [
    "AC",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "-",
    "C",
    "0",
    ".",
    "=",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.79,
              child: _resultWidget(),
            ),
            Expanded(child: _buttonWidget()),
          ],
        ),
      ),
    );
  }

  Widget _resultWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              userInput,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color.fromARGB(66, 233, 232, 232),
      child: GridView.builder(
          itemCount: buttonList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            return _button(buttonList[index]);
          }),
    );
  }

  getColor(String text) {
    if (text == "/" ||
        text == "+" ||
        text == "-" ||
        text == "*" ||
        text == "(" ||
        text == ")" ||
        text == "C") {
      return Colors.redAccent;
    } else if (text == "=" || text == "AC") {
      return Colors.white;
    } else {
      return Colors.indigoAccent;
    }
  }

  getBGColor(String text) {
    if (text == 'AC') {
      return Colors.redAccent;
    } else if (text == "=") {
      return const Color.fromARGB(255, 104, 204, 159);
    } else {
      return Colors.white;
    }
  }

  Widget _button(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          handlePressedButton(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: getBGColor(text),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: getColor(text),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  handlePressedButton(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    }

    if (text == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }

    if (text == "=") {
      result = calculate();
      userInput = result;

      if (userInput.endsWith(".0")) {
        userInput = userInput.replaceAll(".0", "");
      }
      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
      }
      return;
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "Error";
    }
  }
}
