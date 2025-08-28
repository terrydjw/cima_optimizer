import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import '../../features/practice/providers/quiz_provider.dart';

class CalculatorDialog extends StatefulWidget {
  const CalculatorDialog({super.key});

  @override
  State<CalculatorDialog> createState() => _CalculatorDialogState();
}

class _CalculatorDialogState extends State<CalculatorDialog> {
  void _buttonPressed(String buttonText) {
    final quizProvider = context.read<QuizProvider>();
    String currentExpression = quizProvider.calculatorExpression;
    String newExpression = currentExpression;
    String newResult = quizProvider.calculatorResult;

    if (buttonText == "C") {
      newExpression = "";
      newResult = "0";
    } else if (buttonText == "⌫") {
      if (newExpression.isNotEmpty) {
        newExpression = newExpression.substring(0, newExpression.length - 1);
      }
    } else if (buttonText == "=") {
      try {
        String finalExpression = newExpression
            .replaceAll('×', '*')
            .replaceAll('÷', '/');
        Parser p = Parser();
        Expression exp = p.parse(finalExpression);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        newResult = eval.toStringAsFixed(
          eval.truncateToDouble() == eval ? 0 : 2,
        );
      } catch (e) {
        newResult = "Error";
      }
    } else {
      newExpression += buttonText;
    }

    quizProvider.updateCalculatorState(newExpression, newResult);
  }

  Widget _buildButton(String buttonText, {Color? color, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                color ?? Theme.of(context).primaryColor.withOpacity(0.1),
            foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    return AlertDialog(
      title: const Text('Calculator'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text(
                quizProvider.calculatorExpression,
                style: TextStyle(fontSize: 24, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text(
                quizProvider.calculatorResult,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(),
            Column(
              children: [
                Row(
                  children: [
                    _buildButton("C", color: Colors.orange.shade200),
                    _buildButton("("),
                    _buildButton(")"),
                    _buildButton("÷", color: Colors.blue.shade200),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("×", color: Colors.blue.shade200),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("-", color: Colors.blue.shade200),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("+", color: Colors.blue.shade200),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("^"),
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton("⌫"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton(
                      "=",
                      color: Theme.of(context).colorScheme.primary,
                      flex: 2,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
