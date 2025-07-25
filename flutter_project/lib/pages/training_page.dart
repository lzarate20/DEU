import 'package:flutter/material.dart';
import 'package:flutter_project/pages/training_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/training_service.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final TrainingService _service = TrainingService();
  DateTime _selectedDay = DateTime.now();
  List<Map<String, dynamic>>? _trainingData;

  Future<void> _loadTraining() async {
    final data = await _service.fetchTraining(_selectedDay);
    setState(() {
      _trainingData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTraining();
  }

  @override
  Widget build(BuildContext context) {
    return // En la pantalla principal (lista + calendario)
    Scaffold(
      appBar: AppBar(title: const Text('Entrenamientos')),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _trainingData == null || _trainingData!.isEmpty
                      ? const Center(
                          child: Text('No hay entrenamiento para este día'),
                        )
                      : ListView.builder(
                          itemCount: _trainingData!.length,
                          itemBuilder: (context, index) {
                            final training = _trainingData![index]!;
                            return ListTile(
                              leading: const Icon(Icons.fitness_center),
                              title: Text(training['name'] ?? ''),
                              subtitle: Text(
                                training['exercises'] != null &&
                                        (training['exercises'] as List)
                                            .isNotEmpty
                                    ? training['exercises'][0]['type'] ??
                                          'Ejercicio'
                                    : 'Ejercicio',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/training',
                                  arguments: training,
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ),

          // Calendario a la derecha
          Expanded(
            flex: 2,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: TableCalendar(
                  locale: "es",
                  firstDay: DateTime(2025),
                  lastDay: DateTime(2030),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() => _selectedDay = selectedDay);
                    _loadTraining();
                  },
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  rowHeight: 70,
                  daysOfWeekHeight: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
