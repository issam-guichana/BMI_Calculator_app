import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bmi_calculator/screens/BMIGauge.dart';
import 'package:flutter/services.dart';

class BmiPage extends StatefulWidget {
  BmiPage({super.key});

  @override
  _BmiPageState createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final List<bool> selectedGender = <bool>[true, false];
  bool vertical = false;
  int selectedIndex = 0;

  final TextEditingController _Age_T_F = TextEditingController();
  final TextEditingController _Height_T_F = TextEditingController();
  final TextEditingController _Weight_T_F = TextEditingController();

  double? _bmi;
  double? _idealWeight;
  double? _fat;

  void _calculateBMI() {
    final double? age = double.tryParse(_Age_T_F.text);
    final double? weight = double.tryParse(_Weight_T_F.text);
    final double? heightRaw = double.tryParse(_Height_T_F.text);

    if (weight != null &&
        heightRaw != null &&
        age != null &&
        weight < 650 &&
        heightRaw < 275 &&
        age < 130) {
      final double height = heightRaw / 100;
      setState(() {
        _bmi = weight / (height * height);
        _idealWeight = 22 * (height * height); // Simple ideal weight formula
        if (selectedIndex == 0) {
          _fat = (1.2 * _bmi!) + (0.23 * age) - 5.4 - 10.8;
        } else {
          _fat = (1.2 * _bmi!) + (0.23 * age) - 5.4;
        }
      });
    } else {
      setState(() {
        _bmi = 0;
        _idealWeight = 0;
        _fat = 0;
      });
    }

    if (weight != null &&
        heightRaw != null &&
        weight < 650 &&
        heightRaw < 275) {
      final double height = heightRaw / 100;
      setState(() {
        _bmi = weight / (height * height);
        _idealWeight = 22 * (height * height);
      });
    } else {
      setState(() {
        _bmi = 0;
        _idealWeight = 0;
      });
    }

    if (heightRaw != null && heightRaw < 275) {
      final double height = heightRaw / 100;
      setState(() {
        _idealWeight = 22 * (height * height);
      });
    } else {
      setState(() {
        _idealWeight = 0;
      });
    }
  }

  String _userState() {
    if (_bmi != null) {
      if (_bmi! == 0) {
        return "";
      } else if (_bmi! < 18.5) {
        return "You need to eat more";
      } else if (_bmi! >= 18.5 && _bmi! < 24.9) {
        return "You are in a healthy range";
      } else if (_bmi! >= 25 && _bmi! < 29.9) {
        return "You are overweight";
      } else {
        return "You are obese";
      }
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    _Height_T_F.addListener(_calculateBMI);
    _Weight_T_F.addListener(_calculateBMI);
    _Age_T_F.addListener(_calculateBMI);
  }

  @override
  void dispose() {
    _Height_T_F.removeListener(_calculateBMI);
    _Weight_T_F.removeListener(_calculateBMI);
    _Age_T_F.removeListener(_calculateBMI);
    _Height_T_F.dispose();
    _Weight_T_F.dispose();
    _Age_T_F.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: const Text(
            "BMI Calculator",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (value) {
                // Handle the selected menu item here
                if (value == 'action1') {
                  // Action 1 logic
                } else if (value == 'action2') {
                  _exitApp(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                // const PopupMenuItem<String>(
                //   value: 'action1',
                //   child: Text('Action 1'),
                // ),
                const PopupMenuItem<String>(
                  value: 'action2',
                  child: Text('Exit'),
                ),
              ],
              icon: const Icon(Icons.menu, color: Colors.white), // Menu icon
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < selectedGender.length; i++) {
                        selectedGender[i] = i == index;
                      }
                      selectedIndex = index;
                      _calculateBMI();
                      print('Selected index: $index');
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.red[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.red[200],
                  color: Colors.red[400],
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: selectedGender,
                  children: gender,
                ),
                const SizedBox(height: 10),

                // Text Fields
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _Age_T_F,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red[700]!), // Change the color as needed
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red[
                                700]!), // Change the color for focused state
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red[
                                700]!), // Change the color for enabled state
                      ),
                      labelText: 'AGE',
                      labelStyle: const TextStyle(color: Colors.red),
                      counterText: '',
                    ),
                    maxLength: 3,
                    // Example maximum length
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _Height_T_F,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red[700]!), // Change the color as needed
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red[
                                700]!), // Change the color for focused state
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red[
                                700]!), // Change the color for enabled state
                      ),
                      labelText: 'HEIGHT',
                      labelStyle: const TextStyle(color: Colors.red),
                      counterText: '',
                      suffixText: 'CM',
                      suffixStyle: const TextStyle(color: Colors.red),
                    ),
                    maxLength: 3,
                    // Example maximum length
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _Weight_T_F,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red[700]!), // Change the color as needed
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red[
                                700]!), // Change the color for focused state
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red[
                                700]!), // Change the color for enabled state
                      ),
                      labelText: 'WEIGHT',
                      labelStyle: const TextStyle(color: Colors.red),
                      counterText: '',
                      suffixText: 'KG',
                      suffixStyle: const TextStyle(color: Colors.red),
                    ),
                    maxLength: 3,
                    // Example maximum length
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                ),

                // Numbers ROW
                const SizedBox(height: 25),
                //if (_bmi != null && _idealWeight != null && _fat != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatColumn(
                        label: 'BMI', value: _bmi?.toStringAsFixed(1) ?? '0.0'),
                    const SizedBox(width: 20),
                    _buildStatColumn(
                        label: 'IDEAL WEIGHT',
                        value:
                            '${_idealWeight?.toStringAsFixed(1) ?? '0.0'}kg'),
                    const SizedBox(width: 20),
                    _buildStatColumn(
                        label: 'FAT',
                        value: '${_fat?.toStringAsFixed(1) ?? '0.0'}%'),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: _buildStatText(value: _userState()),
                ),
                const SizedBox(height: 110),
                SizedBox(
                  height: 90,
                  width: 250,
                  child: CustomPaint(
                    painter: BMIGaugePainter(_bmi ?? 0.0),
                  ),
                ),
                const SizedBox(
                  width: 300, // Example width
                  height: 300, // Example height
                  child: Image(
                      image: AssetImage('assets/images/bmi-category.png')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStatColumn({required String label, required String value}) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 24,
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildStatText({required String value}) {
  return Center(
    child: Text(
      value,
      style: TextStyle(
        fontSize: 20,
        color: Colors.red[400],
        //fontWeight: FontWeight.bold,
      ),
    ),
  );
}

const List<Widget> gender = <Widget>[
  Text('Male'),
  Text('Female'),
];

void _exitApp(BuildContext context) {
  SystemNavigator.pop();
}
