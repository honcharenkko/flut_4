import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(PowerCalcApp());
}

class PowerCalcApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Calculations',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Power Calculations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Short Circuit Calculation'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShortCircuitPage()),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Cable Section Calculation'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CableSectionPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShortCircuitPage extends StatefulWidget {
  @override
  _ShortCircuitPageState createState() => _ShortCircuitPageState();
}

class _ShortCircuitPageState extends State<ShortCircuitPage> {
  final TextEditingController unomController = TextEditingController();
  final TextEditingController skController = TextEditingController();
  final TextEditingController xcController = TextEditingController();
  final TextEditingController xtController = TextEditingController();
  final TextEditingController sbController = TextEditingController();
  String result = '';

  void calculate() {
    double Unom = double.parse(unomController.text);
    double Sk = double.parse(skController.text);
    double Xc = double.parse(xcController.text);
    double Xt = double.parse(xtController.text);
    double Sb = double.parse(sbController.text);

    double XSum = Xc + Xt;
    double Ik0 = (Unom * 1000) / (1.732 * XSum);
    double XcPU = Xc * (Sb / Sk);
    double XtPU = Xt * (Sb / Sk);
    double XSumPU = XcPU + XtPU;
    double Ib = Sb / (1.732 * Unom);
    double Ik0PU = Ik0 / Ib;

    setState(() {
      result = 'Σ Impedance: ${XSum.toStringAsFixed(2)} Ω\n'
          'Initial Short-Circuit Current: ${Ik0.toStringAsFixed(2)} kA\n'
          'Σ Impedance in PU: ${XSumPU.toStringAsFixed(2)} PU\n'
          'Short-Circuit Current in PU: ${Ik0PU.toStringAsFixed(2)} PU';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Short Circuit Calculation')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: unomController, decoration: InputDecoration(labelText: 'Unom (kV)')),
            TextField(controller: skController, decoration: InputDecoration(labelText: 'Sk (MVA)')),
            TextField(controller: xcController, decoration: InputDecoration(labelText: 'Xc (Ohm)')),
            TextField(controller: xtController, decoration: InputDecoration(labelText: 'Xt (Ohm)')),
            TextField(controller: sbController, decoration: InputDecoration(labelText: 'Sb (MVA)')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: calculate, child: Text('Calculate')),
            SizedBox(height: 20),
            Text(result, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class CableSectionPage extends StatefulWidget {
  @override
  _CableSectionPageState createState() => _CableSectionPageState();
}

class _CableSectionPageState extends State<CableSectionPage> {
  final TextEditingController SmController = TextEditingController();
  final TextEditingController UnomController = TextEditingController();
  final TextEditingController JekController = TextEditingController();
  final TextEditingController KzController = TextEditingController();
  final TextEditingController FtController = TextEditingController();
  final TextEditingController CtController = TextEditingController();
  String result = '';

  void calculate() {
    double Sm = double.parse(SmController.text);
    double Unom = double.parse(UnomController.text);
    double Jek = double.parse(JekController.text);
    double Kz = double.parse(KzController.text);
    double Ft = double.parse(FtController.text);
    double Ct = double.parse(CtController.text);

    double Izm = Sm / (1.732 * Unom) * 1000;
    double Sek = Izm / Jek;
    double Smin = (Kz * 1000.0 * math.sqrt(Ft)) / Ct;

    setState(() {
      result = 'Operational Current: ${Izm.toStringAsFixed(2)} A\n'
          'Economic Cable Section: ${Sek.toStringAsFixed(2)} mm²\n'
          'Minimum Section for Thermal Stability: ${Smin.toStringAsFixed(2)} mm²\n'
          '${Sek >= Smin ? "Selected section is sufficient." : "Increase cable section!"}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cable Section Calculation')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: SmController, decoration: InputDecoration(labelText: 'Sm (kVA)')),
            TextField(controller: UnomController, decoration: InputDecoration(labelText: 'Unom (kV)')),
            TextField(controller: JekController, decoration: InputDecoration(labelText: 'Jek (A/mm²)')),
            TextField(controller: KzController, decoration: InputDecoration(labelText: 'Kz (kA)')),
            TextField(controller: FtController, decoration: InputDecoration(labelText: 'Ft (sec)')),
            TextField(controller: CtController, decoration: InputDecoration(labelText: 'Ct (A√s/mm²)')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: calculate, child: Text('Calculate')),
            SizedBox(height: 20),
            Text(result, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
