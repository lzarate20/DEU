import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../configProject/global_config.dart';
import '../services/training_service.dart';
import '../widgets/training/training_icon.dart';

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
          final isSmallScreen = constraints.maxWidth < 800; // Umbral para pantalla pequeña

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
                      child: _trainingData == null || _trainingData!.isEmpty
                          ? Center(
                        child: Text(
                          'No hay entrenamiento para este día',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                          : ListView.builder(
                        itemCount: _trainingData!.length,
                        itemBuilder: (context, index) {
                          final training = _trainingData![index]!;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                hoverColor: Colors.grey.withOpacity(0.1),
                                onTap: () {
                                  context.go(
                                    '/training/${training['id']}',
                                    extra: training,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        getTrainingIcon(
                                            training['trainingType'] ?? ''),
                                        color: getTrainingIconColor(
                                            training['trainingType'] ?? ''),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              training['name'] ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              training['description'] ?? '',
                                              maxLines: 2,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.list_alt,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 2),
                                          Text(
                                            training['exercises'] != null
                                                ? '${(training['exercises'] as List).length}'
                                                : '0',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                                child: _buildCalendar(),
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

  Widget _buildCalendar() {
    return TableCalendar(
      locale: "es",
      firstDay: DateTime(2025),
      lastDay: DateTime(2030),
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _selectedDay = selectedDay);
        _loadTraining();
        Navigator.pop(context); // Cierra el modal al seleccionar
      },
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      rowHeight: 60,
      daysOfWeekHeight: 30,
    );
  }

}

