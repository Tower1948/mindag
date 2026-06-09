import 'package:flutter/material.dart';
import 'package:mindag/humorpage.dart';
import 'package:mindag/huskelistepage.dart';
import 'begivenhederpage.dart';
import 'mindaghome.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'mindaginfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Åbn bokse
  await Hive.openBox('humor');
  await Hive.openBox('begivenheder');
  await Hive.openBox('huskeliste');

  // Dato uden tid
  final now = DateTime.now();
  final datoUdenTid = DateTime(now.year, now.month, now.day);

  runApp(MinDagApp(datoUdenTid));
}

class MinDagApp extends StatelessWidget {
  final DateTime dato;

  const MinDagApp(this.dato, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MinDag',

      // ⭐ Forside får startdatoen
      home: Forside(dato: dato),

      // ⭐ Ruter der modtager dato via arguments
      routes: {
        '/MinDagHome': (context) {
          final dato = ModalRoute.of(context)!.settings.arguments as DateTime;
          return MinDagHome(dato: dato);
        },
        '/Huskeliste': (context) {
          final dato = ModalRoute.of(context)!.settings.arguments as DateTime;
          return HuskelistePage(dato: dato);
        },
        '/Humorside': (context) {
          final dato = ModalRoute.of(context)!.settings.arguments as DateTime;
          return HumorPage(dato: dato);
        },
        '/Info': (context) {
          final dato = ModalRoute.of(context)!.settings.arguments as DateTime;
          return InfoSide(dato: dato);
        },
        '/begivenheder': (context) {
          final dato = ModalRoute.of(context)!.settings.arguments as DateTime;
          return BegivenhederPage(dato: dato);
        },
      },
    );
  }
}

class Forside extends StatelessWidget {
  final DateTime dato;

  const Forside({super.key, required this.dato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Tjek.png', width: 300),

              const SizedBox(height: 30),

              const Text(
                'Velkommen til MinDag',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                "${dato.day}-${dato.month}-${dato.year}",
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/MinDagHome',
                      arguments: dato,
                    );
                  },
                  child: const Text(
                    'Sådan gik min dag',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
