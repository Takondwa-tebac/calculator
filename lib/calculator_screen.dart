import "package:calculator/button_values.dart";
import "package:flutter/material.dart";

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return  Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
             Expanded(
               child: SingleChildScrollView(
                 reverse: true,
                 child: Container(
                   alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                             ),
               ),
             ),
            // buttons
            Wrap(
              children: Btn.buttonValues.map((value) => SizedBox(
                  width: value == Btn.n0 ? screen.width /2 : (screen.width/4),
                  height: screen.width/5,
                  child: buildButton(value))).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(el){
    return  Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(el),
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () => onBtnTap(el),
          child: Center(
              child: Text(
                el,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),

              )
          ),
        ),
      ),
    );
  }

  // on tap btn
  void onBtnTap(String value){

    if(value == Btn.del){
      delete();
      return;
    }

    if(value == Btn.clr){
      clearAll();
      return;
    }

    if(value == Btn.per){
      convertToPercentage();
      return;
    }

    if(value == Btn.calculate){
      calculate();
      return;
    }

    appendValue(value);
  }


 void  appendValue (String value){


   // check if not a number and is operand
   if(value != Btn.dot && int.tryParse(value) == null){
     if(operand.isNotEmpty && number2.isNotEmpty){
       // todo calculate the equation before assgning new operand
       calculate();
     }
     operand = value;
   }
   // assign value to number 1
   else if (number1.isEmpty || operand.isEmpty){
     // "21" "+" ""
     if(value == Btn.dot && number1.contains(Btn.dot)) return;
     if(value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)){
       value = "0.";
     };

     number1 += value;

   }
   // assign value to number 2
   else if (number2.isEmpty || operand.isNotEmpty){
     // "21" "+" ""
     if(value == Btn.dot && number2.contains(Btn.dot)) return;
     if(value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)){
       value = "0.";
     };

     number2 += value;
   }

   setState(() {});

 }

 // delete function;

 void delete(){
    // 1234 => 123
    if(number2.isNotEmpty){
      number2= number2.substring(0,number2.length -1);
    }else if(operand.isEmpty){
      operand = "";
    } else if(number1.isNotEmpty){
      number1= number1.substring(0,number1.length -1);

    }

    setState(() {});
 }

 // clear all functions

 void clearAll(){
    setState(() {
      number2 = "";
      number1 = "";
      operand = "";
    });
 }

  // convert to percentage
  void convertToPercentage(){
    if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){
      // calculate before conversion;
      calculate();
    }

    if(operand.isNotEmpty){
      // can not be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${ (number /100) }";
      operand = "";
      number2 = "";
    });
  }

  // calculate values
  void calculate(){
    if(number1.isEmpty && number2.isEmpty && operand.isEmpty) return;

    final double num1= double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch(operand){
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = "$result";
      if(number1.endsWith(".0")){
        number1 = number1.substring(0, number1.length -2);
      };

      operand = "";
      number2 = "";
    });

  }

  // ########
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)
        ? Colors.lightBlue
        : Colors.black87;
  }
}





