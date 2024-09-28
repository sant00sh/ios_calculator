import 'package:flutter/material.dart';
import '../core/constants.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _currentValue = '0';
  String _operation = '';
  String _previousValue = '';
  bool _shouldResetCurrentValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _topPanel(),
          _bottomPanel(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _topPanel() => Expanded(
        child: Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            _currentValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 60,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      );

  Widget _bottomPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = constraints.maxWidth / 4;
        double itemHeight = itemWidth;

        return Wrap(
          children: calcOperators.entries.map((entry) {
            String key = entry.key;
            dynamic value = entry.value;

            if (key == "0") {
              return _buildButton(
                  key, value["label"], itemWidth * 2, itemHeight);
            } else {
              return _buildButton(key, value is String ? value : value["label"],
                  itemWidth, itemHeight);
            }
          }).toList(),
        );
      },
    );
  }

  Widget _buildButton(String label, String value, double width, double height) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: _getColor(label),
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: TextButton(
          onPressed: () => _onPressed(value),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  Color _getColor(String label) {
    switch (label) {
      case "AC":
      case "+/-":
      case "%":
        return Colors.grey[850]!;
      case "÷":
      case "x":
      case "-":
      case "+":
      case "=":
        return Colors.orange;
      default:
        return Colors.grey.shade800;
    }
  }

  void _onPressed(String value) {
    switch (value) {
      case 'AC':
        _allClear();
        break;
      case 'toggleSign':
        _toggleSign();
        break;
      case 'percent':
        _percentage();
        break;
      case 'divide':
      case 'multiply':
      case 'subtract':
      case 'add':
        _setOperation(value);
        break;
      case 'equals':
        _calculate();
        break;
      case 'decimal':
        _addDecimal();
        break;
      default:
        _addDigit(value);
    }
  }

  void _allClear() {
    setState(() {
      _currentValue = '0';
      _operation = '';
      _previousValue = '';
      _shouldResetCurrentValue = false;
    });
  }

  void _toggleSign() {
    setState(() {
      if (_currentValue != '0') {
        if (_currentValue.startsWith('-')) {
          _currentValue = _currentValue.substring(1);
        } else {
          _currentValue = '-$_currentValue';
        }
      }
    });
  }

  void _percentage() {
    setState(() {
      double value = double.parse(_currentValue);
      _currentValue = (value / 100).toString();
    });
  }

  void _setOperation(String operation) {
    setState(() {
      if (_previousValue.isNotEmpty) {
        _calculate();
      }
      _operation = operation;
      _previousValue = _currentValue;
      _shouldResetCurrentValue = true;
    });
  }

  void _calculate() {
    if (_previousValue.isEmpty || _operation.isEmpty) return;

    double prev = double.parse(_previousValue);
    double current = double.parse(_currentValue);
    double result = 0;

    switch (_operation) {
      case 'add':
        result = prev + current;
        break;
      case 'subtract':
        result = prev - current;
        break;
      case 'multiply':
        result = prev * current;
        break;
      case 'divide':
        if (current != 0) {
          result = prev / current;
        } else {
          _currentValue = 'Error';
          return;
        }
        break;
    }

    setState(() {
      _currentValue = result.toString();
      _operation = '';
      _previousValue = '';
      _shouldResetCurrentValue = true;
    });
  }

  void _addDecimal() {
    setState(() {
      if (!_currentValue.contains('.')) {
        _currentValue += '.';
      }
    });
  }

  void _addDigit(String digit) {
    setState(() {
      if (_shouldResetCurrentValue) {
        _currentValue = digit;
        _shouldResetCurrentValue = false;
      } else {
        _currentValue = (_currentValue == '0') ? digit : _currentValue + digit;
      }
    });
  }
}
