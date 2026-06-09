import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HumorPage extends StatefulWidget {
  final DateTime? dato; // ⭐ valgfri dato, så både constructor og route virker

  const HumorPage({super.key, this.dato});

  @override
  State<HumorPage> createState() => _HumorPageState();
}

class _HumorPageState extends State<HumorPage> {
  final List<String> emojis = ["😞", "😐", "🙂", "😄", "🤩"];
  String valgt = "";

  late DateTime dato;
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

    // ⭐ Hent gemt humør
    final box = Hive.box('humor');
    final gemt = box.get(key);

    if (gemt != null && gemt is String) {
      valgt = gemt;
    }
  }

  void gemHumor() {
    final box = Hive.box('humor');
    box.put(key, valgt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD54F),
        title: const Text("Mit humør"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ⭐ Dato øverst
          Text(
            "${dato.day}-${dato.month}-${dato.year}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          const Text(
            "Hvordan har du det i dag?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          // ⭐ Emoji-rækken
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: emojis.map((emoji) {
              final bool erValgt = valgt == emoji;
              return GestureDetector(
                onTap: () => setState(() => valgt = emoji),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: erValgt
                        ? Border.all(color: const Color(0xFF8BC34A), width: 4)
                        : null,
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 40)),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 40),

          // ⭐ Gem-knap
          ElevatedButton(
            onPressed: () {
              gemHumor();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Humør gemt!")));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            ),
            child: const Text("Gem humør", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
