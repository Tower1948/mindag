import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

class MinDagHome extends StatefulWidget {
  final DateTime dato;

  const MinDagHome({super.key, required this.dato});

  @override
  State<MinDagHome> createState() => _MinDagHomeState();
}

class _MinDagHomeState extends State<MinDagHome> {
  late DateTime _valgtDato;

  final humorBox = Hive.box('humor');
  final begivenhederBox = Hive.box('begivenheder');
  final huskelisteBox = Hive.box('huskeliste');

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('da_DK', null).then((_) {
      setState(() {}); // Opdater UI efter initialisering
    });
    _valgtDato = widget.dato;
  }

  bool harData(DateTime dag) {
    final key = "${dag.year}-${dag.month}-${dag.day}";
    return humorBox.get(key) != null ||
        begivenhederBox.get(key) != null ||
        huskelisteBox.get(key) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD54F),
        title: const Text("Min Dag"),
        centerTitle: true,
      ),
      // ⭐ HER ER ÆNDRINGEN: Tilføjet SingleChildScrollView
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ⭐ STOR KALENDER
              TableCalendar(
                locale: 'da_DK',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _valgtDato,
                selectedDayPredicate: (day) =>
                    day.year == _valgtDato.year &&
                    day.month == _valgtDato.month &&
                    day.day == _valgtDato.day,

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _valgtDato = selectedDay;
                  });

                  // Navigér til MinDagHome med ny dato
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MinDagHome(dato: selectedDay),
                    ),
                  );
                },

                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.yellow[700],
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,

                  // ⭐ Farv dage med data
                  markerDecoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),

                // ⭐ Markeringer (prikker) under dage med data
                eventLoader: (day) {
                  return harData(day) ? ["data"] : [];
                },
              ),

              const SizedBox(height: 30),

              // ⭐ Menupunkter
              _menuButton(
                context,
                "Huskeliste",
                Icons.checklist,
                "/Huskeliste",
              ),
              const SizedBox(height: 20),
              _menuButton(context, "Humør", Icons.emoji_emotions, "/Humorside"),
              const SizedBox(height: 20),
              _menuButton(
                context,
                "Særlige begivenheder",
                Icons.star,
                "/begivenheder",
              ),
              const SizedBox(height: 20), // Tilføjet lidt luft her
              _menuButton(context, "Info", Icons.info, "/Info"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context,
    String text,
    IconData icon,
    String route,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8BC34A),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () =>
          Navigator.pushNamed(context, route, arguments: _valgtDato),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }
}
