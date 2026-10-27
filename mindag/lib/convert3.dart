import 'dart:convert';
import 'dart:io';

void main() {
  // Læs JSON-fil
  final jsonFile = File("mindag_begivenheder.json");

  if (!jsonFile.existsSync()) {
    print("Filen mindag_begivenheder.json blev ikke fundet.");
    return;
  }

  final jsonString = jsonFile.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(jsonString);

  final result = <String, Map<String, String>>{};

  // Gennemløb alle datoer
  for (final entry in data.entries) {
    final dato = entry.key;
    final begivenheder = entry.value as List;

    result.putIfAbsent(
      dato,
      () => {
        "morgen": "",
        "aften": "",
      },
    );

    for (final begivenhed in begivenheder) {
      final tekst = begivenhed.toString().toLowerCase();

      if (!tekst.contains("klokken")) {
        continue;
      }

      // Matcher fx:
      // klokken 9: 36,6
      // klokken 18: 37,6
      // klokken 18.30: 37,6
      final match = RegExp(
        r'klokken\s+(\d{1,2})(?:[.:]\d{1,2})?\s*:\s*([0-9]+,[0-9]+)',
        caseSensitive: false,
      ).firstMatch(begivenhed.toString());

      if (match == null) continue;

      final time = int.parse(match.group(1)!);
      final temperatur = match.group(2)!;

      if (time < 12) {
        result[dato]!["morgen"] = temperatur;
      } else {
        result[dato]!["aften"] = temperatur;
      }
    }
  }

  // Sortér datoerne
  final datoer = result.keys.toList();

  datoer.sort((a, b) {
    final pa = a.split('-').map(int.parse).toList();
    final pb = b.split('-').map(int.parse).toList();

    return DateTime(pa[0], pa[1], pa[2])
        .compareTo(DateTime(pb[0], pb[1], pb[2]));
  });

  final out = StringBuffer();
  out.writeln("dato;morgen;aften");

  for (final dato in datoer) {
    out.writeln(
      "$dato;${result[dato]!["morgen"]};${result[dato]!["aften"]}",
    );
  }

  File("temperatur_opdelt.csv").writeAsStringSync(out.toString());

  print("Færdig!");
  print("temperatur_opdelt.csv er oprettet.");
}