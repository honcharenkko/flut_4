import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Головний Екран',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Головний Екран')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReliabilityCalculator()),
                );
              },
              child: Text('Перше завдання'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnergyLossCalculator()),
                );
              },
              child: Text('Друге завдання'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReliabilityCalculator extends StatefulWidget {
  @override
  _ReliabilityCalculatorState createState() => _ReliabilityCalculatorState();
}

class _ReliabilityCalculatorState extends State<ReliabilityCalculator> {
  final TextEditingController pvController = TextEditingController();
  final TextEditingController kpController = TextEditingController();
  final TextEditingController tController = TextEditingController();

  double? qo, tavg, ka, mEnergy;

  void calculate() {
    double pv = double.tryParse(pvController.text) ?? 0;
    double kp = double.tryParse(kpController.text) ?? 0;
    double t = double.tryParse(tController.text) ?? 0;

    setState(() {
      qo = 0.015; // Значення для прикладу
      tavg = 100;
      ka = (qo! * tavg!) / 8760;
      mEnergy = kp * pv * t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Перше завдання')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: pvController, decoration: InputDecoration(labelText: 'Навантаження (МВт)')),
            TextField(controller: kpController, decoration: InputDecoration(labelText: 'Коефіцієнт використання')),
            TextField(controller: tController, decoration: InputDecoration(labelText: 'Час роботи (год)')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: calculate, child: Text('Розрахувати')),
            if (qo != null)
              Column(
                children: [
                  Text('Частота відмов: ${qo!.toStringAsFixed(4)}'),
                  Text('Втрати енергії: ${mEnergy!.toStringAsFixed(2)} МВт·год'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class EnergyLossCalculator extends StatefulWidget {
  @override
  _EnergyLossCalculatorState createState() => _EnergyLossCalculatorState();
}

class _EnergyLossCalculatorState extends State<EnergyLossCalculator> {
  final TextEditingController pwtController = TextEditingController();
  final TextEditingController kpController = TextEditingController();
  final TextEditingController tController = TextEditingController();
  final TextEditingController wvtController = TextEditingController();

  double? mav, mwvt, mtotal;

  void calculateLosses() {
    double pwt = double.tryParse(pwtController.text) ?? 0;
    double kp = double.tryParse(kpController.text) ?? 0;
    int t = int.tryParse(tController.text) ?? 0;
    double wvt = double.tryParse(wvtController.text) ?? 0;

    setState(() {
      mav = kp * pwt * t;
      mwvt = kp * t * 4e-3 * 5.12e2 * wvt;
      mtotal = (23.6 * mav!) + (17.6 * mwvt!) - 2682000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Друге завдання')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: pwtController, decoration: InputDecoration(labelText: 'Навантаження (МВт)')),
            TextField(controller: kpController, decoration: InputDecoration(labelText: 'Коефіцієнт використання')),
            TextField(controller: tController, decoration: InputDecoration(labelText: 'Час роботи (год)')),
            TextField(controller: wvtController, decoration: InputDecoration(labelText: 'Параметр W (Вт)')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: calculateLosses, child: Text('Розрахувати')),
            if (mav != null)
              Column(
                children: [
                  Text('Втрати автотрансформатора: ${mav!.toStringAsFixed(2)} кВт·год'),
                  Text('Втрати електропередачі: ${mwvt!.toStringAsFixed(2)} кВт·год'),
                  Text('Загальні втрати: ${mtotal!.toStringAsFixed(2)} кВт·год'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
