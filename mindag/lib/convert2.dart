import 'dart:io';

void main() {
  final lines = File("kunTemperatur.csv").readAsLinesSync();

  // Ignorer de første tre linjer
  final dataLines = lines.skip(3);

  final result = <String, Map<String, String>>{};

  bool isTime(String value) {
    // Tjek om col2 er tid (fx 7, 22, 8)
    try {
      final v = double.parse(value.replaceAll(",", "."));
      return v < 30; // tid er typisk 0-23
    } catch (_) {
      return false;
    }
  }

  for (var line in dataLines) {
    if (line.trim().isEmpty) continue;

    final parts = line.split(";");

    if (parts.length < 3) continue;

    final dato = parts[0];
    final col2 = parts[1].replaceAll(",", ".");
    final col3 = parts[2].replaceAll(",", ".");

    result.putIfAbsent(dato, () => {"morgen": "", "aften": ""});

    if (isTime(col2)) {
      // Format: dato ; tid ; temperatur
      final tid = double.parse(col2);
      final temp = col3;

      if (tid < 12) {
        result[dato]!["morgen"] = temp;
      } else {
        result[dato]!["aften"] = temp;
      }
    } else {
      // Format: dato ; morgen ; aften
      result[dato]!["morgen"] = col2;
      result[dato]!["aften"] = col3;
    }
  }

  final out = StringBuffer("dato;morgen;aften\n");

  result.forEach((dato, temps) {
    out.writeln("$dato;${temps["morgen"]};${temps["aften"]}");
  });

  File("temperatur_opdelt.csv").writeAsStringSync(out.toString());

  print("Ny fil gemt som temperatur_opdelt.csv");
}
