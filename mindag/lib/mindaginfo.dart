import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class InfoSide extends StatefulWidget {
  final DateTime dato;

  const InfoSide({super.key, required this.dato});

  @override
  State<InfoSide> createState() => _InfoSideState();
}

class _InfoSideState extends State<InfoSide> {
  String tekstFraFil = "";

  @override
  void initState() {
    super.initState();
    loadText();
  }

  Future<void> loadText() async {
    final tekst = await rootBundle.loadString('assets/Texts/Info.txt');
    setState(() {
      tekstFraFil = tekst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8D6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD54F),
        title: const Text("Info side"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ Dato øverst
            Text(
              "${widget.dato.day}-${widget.dato.month}-${widget.dato.year}",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ⭐ Scrollbart tekstfelt fra assets
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  tekstFraFil.isEmpty ? "Indlæser..." : tekstFraFil,
                  style: const TextStyle(fontSize: 18, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
