import 'package:flutter/material.dart';
import 'dart:math'; // For advanced math functions

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  // Stores the current input expression as a string
  String _input = '';
  // Stores the result of the calculation as a string
  String _result = '';

  // Handles button presses and updates the input/result accordingly
  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        // Clear input and result
        _input = '';
        _result = '';
      } else if (value == '⌫') {
        // Remove last character (backspace)
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == '=') {
        // Calculate the result
        try {
          _result = _calculateResult(_input);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        // Append the pressed value to the input
        _input += value;
      }
    });
  }

  // Calculates the result of the input expression
  String _calculateResult(String input) {
    try {
      // Replace symbols with Dart operators
      String expression = input
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('^', '**')
          .replaceAll('%', '/100')
          .replaceAll('√', 'sqrt');
      // Evaluate the expression
      double result = _evaluateExpression(expression);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  // Evaluates a mathematical expression string and returns the result as double
  double _evaluateExpression(String expr) {
    // This is a simple recursive descent parser for demo purposes
    // Supports +, -, *, /, ^, %, sqrt, sin, cos, tan, log, parentheses, decimals
    // For production, use a math expression package
    expr = expr.replaceAll(' ', ''); // Remove spaces
    double parseExpression(int start, int end) {
      // Helper to parse an expression from expr[start] to expr[end-1]
      int i = end - 1;
      int paren = 0;
      // Handle addition and subtraction
      for (; i >= start; i--) {
        if (expr[i] == ')') paren++;
        if (expr[i] == '(') paren--;
        if (paren == 0) {
          if (expr[i] == '+') {
            return parseExpression(start, i) + parseExpression(i + 1, end);
          } else if (expr[i] == '-' && i > start) {
            return parseExpression(start, i) - parseExpression(i + 1, end);
          }
        }
      }
      // Handle multiplication, division, and modulus
      i = end - 1;
      for (; i >= start; i--) {
        if (expr[i] == ')') paren++;
        if (expr[i] == '(') paren--;
        if (paren == 0) {
          if (expr[i] == '*') {
            return parseExpression(start, i) * parseExpression(i + 1, end);
          } else if (expr[i] == '/') {
            return parseExpression(start, i) / parseExpression(i + 1, end);
          } else if (expr[i] == '%') {
            return parseExpression(start, i) % parseExpression(i + 1, end);
          }
        }
      }
      // Handle exponentiation
      i = end - 1;
      for (; i >= start; i--) {
        if (expr[i] == ')') paren++;
        if (expr[i] == '(') paren--;
        if (paren == 0 && expr[i] == '^') {
          return pow(parseExpression(start, i), parseExpression(i + 1, end)).toDouble();
        }
      }
      // Handle functions and parentheses
      if (expr[start] == '(' && expr[end - 1] == ')') {
        return parseExpression(start + 1, end - 1);
      }
      // Functions: sqrt, sin, cos, tan, log
      String sub = expr.substring(start, end);
      if (sub.startsWith('sqrt')) {
        return sqrt(parseExpression(start + 4, end));
      } else if (sub.startsWith('sin')) {
        return sin(parseExpression(start + 3, end));
      } else if (sub.startsWith('cos')) {
        return cos(parseExpression(start + 3, end));
      } else if (sub.startsWith('tan')) {
        return tan(parseExpression(start + 3, end));
      } else if (sub.startsWith('log')) {
        return log(parseExpression(start + 3, end));
      }
      // Parse number
      return double.parse(sub);
    }
    return parseExpression(0, expr.length);
  }

  // Builds a calculator button with a label and optional color
  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Padding around the button
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color.fromARGB(255, 105, 103, 103), // Button color
            padding: const EdgeInsets.symmetric(vertical: 20), // Button size
          ),
          onPressed: () => _onPressed(text), // Button press handler
          child: Text(
            text,
            style: const TextStyle(fontSize: 34, color: Color.fromARGB(255, 251, 251, 251)), // Button text style
          ),
        ),
      ),
    );
  }

  // Builds the calculator UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          // Display area for input and result
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Shows the current input
                  Text(
                    _input,
                    style: const TextStyle(fontSize: 100, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  // Shows the result
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 100, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          // Calculator buttons
          Column(
            children: [
              // Top row: scientific functions, percent, clear, backspace
              Row(
                children: [
                  _buildButton('sin', color: Colors.grey), // Sine function
                  _buildButton('cos', color: Colors.grey), // Cosine function
                  _buildButton('tan', color: Colors.grey), // Tangent function
                  _buildButton('log', color: Colors.grey), // Logarithm
                  _buildButton('%', color: Colors.grey), // Percentage
                  _buildButton('C', color: Colors.blueGrey), // Clear
                  _buildButton('⌫', color: Colors.blueGrey), // Backspace
                ],
              ),
              Row(
                children: [
                  _buildButton('√', color: Colors.grey), // Square root
                  _buildButton('(', color: Colors.grey), // Left parenthesis
                  _buildButton(')', color: Colors.grey), // Right parenthesis
                  _buildButton('^', color: Colors.grey), // Exponentiation
                ],
              ),
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('÷', color: Colors.blueGrey), // Division
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('×', color: Colors.blueGrey), // Multiplication
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-', color: Colors.blueGrey), // Subtraction
                ],
              ),
              Row(
                children: [
                  _buildButton('0'),
                  _buildButton('.'), // Decimal point
                  _buildButton('=', color: Colors.blueGrey), // Equals
                  _buildButton('+', color: Colors.blueGrey), // Addition
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
