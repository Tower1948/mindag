import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HuskelistePage extends StatefulWidget {
  final DateTime? dato; // ⭐ gør dato valgfri, så route-arguments også virker

  const HuskelistePage({super.key, this.dato});

  @override
  State<HuskelistePage> createState() => _HuskelistePageState();
}

class _HuskelistePageState extends State<HuskelistePage> {
  late DateTime dato;

  final Map<String, bool> aktiviteter = {
    "Spist morgenmad": false,
    "Gået en tur": false,
    "Været i haven": false,
    "Været hos lægen, apoteket, behandling": false,
    "Købt ind": false,
    "Kørt bil": false,
    "Ladet bil op": false,
    "Venner på besøg eller besøge venner": false,
    "Famile på besøg eller besøge familie": false,
    "Vasket tøj": false,
    "Set TV og læst nyheder": false,
    "Spillet et spil eller løst en gåde eller krydsord": false,
    "Støvsuget": false,
    "Til koncert": false,
    "På museum": false,
    "På cafe": false,
    "Haft en god oplevelse": false,
    "Stod op før kl. 8": false,
    "Gik i seng før kl. 22": false,
  };

  late String key;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ⭐ Brug dato fra constructor hvis den findes
    if (widget.dato != null) {
      dato = widget.dato!;
    } else {
      // ⭐ Ellers hent dato fra route arguments
      dato = ModalRoute.of(context)!.settings.arguments as DateTime;
    }

    // ⭐ Lav nøgle
    key = "${dato.year}-${dato.month}-${dato.day}";

    // ⭐ Hent gemte data
    final box = Hive.box('huskeliste');
    final gemt = box.get(key);

    if (gemt != null && gemt is Map) {
      gemt.forEach((k, v) {
        if (aktiviteter.containsKey(k)) {
          aktiviteter[k] = v == true;
        }
      });
    }
  }

  void gemData() {
    final box = Hive.box('huskeliste');
    box.put(key, aktiviteter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD54F),
        title: const Text("Ting jeg vil huske"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "${dato.day}-${dato.month}-${dato.year}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ...aktiviteter.keys.map((aktivitet) {
            return CheckboxListTile(
              title: Text(aktivitet),
              value: aktiviteter[aktivitet],
              activeColor: const Color(0xFF8BC34A),
              onChanged: (value) {
                setState(() {
                  aktiviteter[aktivitet] = value!;
                });
              },
            );
          }),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              gemData();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 183, 238, 120),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              "Gem dagens spor",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 10, 10, 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
