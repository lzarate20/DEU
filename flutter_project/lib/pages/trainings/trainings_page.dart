import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../configProject/global_config.dart';
import '../../services/training_service.dart';
import '../../services/user_service.dart';
import '../../widgets/search_filter.dart';
import '../../widgets/trainer/training_card.dart';

class TrainingListPage extends StatefulWidget {
  const TrainingListPage({super.key});

  @override
  State<TrainingListPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingListPage> with RouteAware {
  final TrainingService _service = TrainingService();
  final UserService _userService = UserService();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> _trainings = [];
  List<Map<String, dynamic>> _users = [];

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    _searchController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadData();
  }


  Future<void> _loadData() async {
    final trainings = await _service.fetchTrainings() ?? [];
    final users = await _userService.fetchUsers();
    print(trainings);
    setState(() {
      _trainings = trainings;
      _users = users;
    });
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());
    final firstDate = DateTime(2020);
    final lastDate = DateTime(2030);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTrainings = _trainings.where((training) {
      final name = (training['name'] ?? '').toString().toLowerCase();
      final trainingType = (training['trainingType'] ?? '').toString().toLowerCase();
      final dateStr = training['date'] ?? '';
      final trainerId = training['trainer']?['id'];

      final trainer = _users.firstWhere(
            (user) => user['id'] == trainerId,
        orElse: () => {'name': ''},
      );
      final trainerName = (trainer['name'] ?? '').toString().toLowerCase();

      final matchesText = _searchQuery.isEmpty ||
          name.contains(_searchQuery) ||
          trainingType.contains(_searchQuery) ||
          trainerName.contains(_searchQuery);

      DateTime? trainingDate;
      try {
        trainingDate = DateTime.parse(dateStr);
      } catch (_) {}

      bool matchesDate = true;
      if (_startDate != null || _endDate != null) {
        if (trainingDate == null) {
          matchesDate = false;
        } else {
          if (_startDate != null && trainingDate.isBefore(_startDate!)) {
            matchesDate = false;
          }
          if (_endDate != null && trainingDate.isAfter(_endDate!)) {
            matchesDate = false;
          }
        }
      }

      return matchesText && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenamientos'),
      ),
      body: Column(
        children: [
          SearchFilters(
            controller: _searchController,
            onSearch: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            startDate: _startDate,
            endDate: _endDate,
            onPickStartDate: () => _pickDate(context, true),
            onPickEndDate: () => _pickDate(context, false),
            onClearDates: () {
              setState(() {
                _startDate = null;
                _endDate = null;
              });
            },
          ),
          Expanded(
            child: _trainings.isEmpty || _users.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filteredTrainings.isEmpty
                ? const Center(child: Text('No hay entrenamientos disponibles.'))
                : ListView.builder(
              itemCount: filteredTrainings.length,
              itemBuilder: (context, index) {
                final training = filteredTrainings[index];
                final trainerId = training['trainer']?['id'];
                final trainer = _users.firstWhere(
                      (user) => user['id'] == trainerId,
                  orElse: () => {'name': 'Desconocido'},
                );

                return TrainingCard(
                  training: training,
                  trainer: trainer,
                  onTap: () {
                    context.go('/training/${training['id']}', extra: training);
                  },
                  onAdd: () {},
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/training/new');
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear nuevo entrenamiento',
      ),
    );
  }

}
