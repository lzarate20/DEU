import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../configProject/global_config.dart';
import '../services/training_service.dart';
import '../widgets/training/training_icon.dart';
import '../widgets/training/trainings_list_widget.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> with RouteAware {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadTraining();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800;

          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TrainingsList(trainings: _trainingData ?? []),
                    ),
                  ),
                ),
              ),
              if (!isSmallScreen)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _buildCalendar(),
                    ),
                  ),
                ),
              if (isSmallScreen)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: _buildCalendar(isSmallScreen: true),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text("Seleccionar día"),
                        ),
                      ),
                    ],
                  ),
                ),

            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar({bool isSmallScreen = false}) {
    return TableCalendar(
      locale: "es",
      firstDay: DateTime(2025),
      lastDay: DateTime(2030),
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _selectedDay = selectedDay);
        _loadTraining();
        if (isSmallScreen) {
          Navigator.pop(context);
        }
      },
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      rowHeight: 60,
      daysOfWeekHeight: 30,
    );
  }


}

