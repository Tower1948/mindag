import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BegivenhederPage extends StatefulWidget {
  final DateTime? dato; // ⭐ valgfri dato, så både constructor og route virker

  const BegivenhederPage({super.key, this.dato});

  @override
  State<BegivenhederPage> createState() => _BegivenhederPageState();
}

class _BegivenhederPageState extends State<BegivenhederPage> {
  final TextEditingController controller = TextEditingController();
  final List<String> begivenheder = [];

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

    // ⭐ Hent gemte begivenheder (kun én gang)
    final box = Hive.box('begivenheder');
    final gemt = box.get(key);

    if (gemt != null && gemt is List) {
      begivenheder.clear();
      begivenheder.addAll(gemt.cast<String>());
    }
  }

  void gemBegivenheder() {
    final box = Hive.box('begivenheder');
    box.put(key, begivenheder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD54F),
        title: const Text("Særlige begivenheder"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ⭐ Dato øverst
            Text(
              "${dato.day}-${dato.month}-${dato.year}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ⭐ Inputfelt
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Dagens begivenhed",
                hintText: "F.eks. 'Fødselsdag', 'Rejse', 'Hospital'",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final text = value.trim();
                if (text.isEmpty) return;
                setState(() {
                  begivenheder.add(text);
                  controller.clear();
                });
                gemBegivenheder();
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                setState(() {
                  begivenheder.add(text);
                  controller.clear();
                });
                gemBegivenheder();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Begivenhed tilføjet!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 40,
                ),
              ),
              child: const Text(
                "Tilføj begivenhed",
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ Liste over begivenheder
            Expanded(
              child: begivenheder.isEmpty
                  ? const Center(child: Text("Ingen begivenheder endnu"))
                  : ListView.builder(
                      itemCount: begivenheder.length,
                      itemBuilder: (context, index) {
                        final begivenhed = begivenheder[index];
                        return ListTile(
                          title: Text(begivenhed),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                begivenheder.removeAt(index);
                              });
                              gemBegivenheder();
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
