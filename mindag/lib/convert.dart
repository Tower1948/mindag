import 'dart:convert';
import 'dart:io';

void main() {
  // Indlæs JSON-filen
  final jsonFile = File("mindag_begivenheder.json");
  final jsonString = jsonFile.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(jsonString);

  // Konverter nøgler (datoer) til DateTime + behold original streng
  final entries = data.entries.map((e) {
    final datoStr = e.key; // fx "2026-5-20"
    final parts = datoStr.split('-');

    // Lav en DateTime der kan sorteres
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    final dato = DateTime(year, month, day);

    return {"dato": dato, "datoStr": datoStr, "begivenheder": e.value as List};
  }).toList();

  // Sortér efter dato
  entries.sort(
    (a, b) => (a["dato"] as DateTime).compareTo(b["dato"] as DateTime),
  );

  // Opret CSV-fil
  final csvFile = File("mindag_begivenheder.csv");
  final sink = csvFile.openWrite();

  // Header
  sink.writeln("dato;begivenhed");

  // Skriv alle linjer
  for (var entry in entries) {
    final datoStr = entry["datoStr"];
    final begivenheder = entry["begivenheder"] as List;

    for (var begivenhed in begivenheder) {
      sink.writeln("$datoStr;$begivenhed");
    }
  }

  sink.close();

  print("Færdig! Filen mindag_begivenheder.csv er lavet og sorteret.");
}
