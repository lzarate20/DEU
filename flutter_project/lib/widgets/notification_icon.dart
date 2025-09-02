import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/services/training_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return isoString;
    }
  }

  Future<void> _loadNotifications() async {
    final result = await UserService().fetchNotifications();
    setState(() {
      notifications = result;
    });
  }

  void _toggleDropdown() async {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);

      final success = await UserService().markNotificationsViewed();
      if (success) {
        setState(() {
          notifications = notifications.map((n) {
            final copy = Map<String, dynamic>.from(n);
            copy['viewed'] = true;
            return copy;
          }).toList();
        });
      }
    } else {
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleNotificationTap(Map<String, dynamic> notif) async {
    final contextData = notif['context'] ?? {};
    final type = contextData['type'];
    final contextId = contextData['contextId'];

    _closeDropdown();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      switch (type) {
        case 'TRAINING':
          final training = await TrainingService().fetchTrainingById(contextId);
          Navigator.pop(context);

          if (training == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se encontró el entrenamiento.')),
            );
            return;
          }

          context.go('/training/${training['id']}', extra: training);
          break;

        case 'team':
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidad de equipo aún no disponible')),
          );
          break;

        default:
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tipo de notificación desconocido')),
          );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar: $e')),
      );
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Detecta taps fuera para cerrar el dropdown
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
            ),
          ),
          // Dropdown
          Positioned(
            width: 250,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(size.width - 250, size.height + 5),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: FocusScope(
                  autofocus: true,
                  canRequestFocus: true,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: notifications.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No hay notificaciones"),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        return ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(notif['message'] ?? ''),
                          subtitle: Text(_formatDate(notif['date'])),
                          dense: true,
                          onTap: () => _handleNotificationTap(notif),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = notifications.where((n) => n['viewed'] == false).length;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Tooltip(
            message: "Notificaciones",
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () async {
                _loadNotifications(); // recarga notificaciones
                final RenderBox button = context.findRenderObject() as RenderBox;
                final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                final selected = await showMenu<Map<String, dynamic>>(
                  context: context,
                  position: RelativeRect.fromRect(
                    Rect.fromPoints(
                      button.localToGlobal(Offset.zero, ancestor: overlay),
                      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                    ),
                    Offset.zero & overlay.size,
                  ),
                  items: notifications.map((notif) {
                    return PopupMenuItem<Map<String, dynamic>>(
                      value: notif,
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(notif['message'] ?? ''),
                        subtitle: Text(_formatDate(notif['date'])),
                      ),
                    );
                  }).toList(),
                );

                if (selected != null) {
                  _handleNotificationTap(selected);
                }
              },
            ),
          ),
          if (count > 0)
            Positioned(
              right: 6,
              top: 6,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}




