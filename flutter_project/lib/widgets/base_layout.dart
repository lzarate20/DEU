import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'header_bar.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 780;

        final baseCompactWidth = 60.0;
        final baseExpandedWidth = 200.0;
        final navWidth =
            (isCompact ? baseCompactWidth : baseExpandedWidth) *
            themeProvider.navSizeFactor;

        return Scaffold(
          body: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: navWidth,
                color: Colors.blue.shade900,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('web/icons/logo2.png'),
                    const SizedBox(height: 20),
                    _NavButton(
                      icon: Icons.home,
                      label: 'Home',
                      compact: isCompact,
                    ),
                    _NavButton(
                      icon: Icons.person,
                      label: 'Entrenamientos',
                      compact: isCompact,
                    ),
                    _NavButton(
                      icon: Icons.group,
                      label: 'Teams',
                      compact: isCompact,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    HeaderBar(),
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool compact;

  const _NavButton({
    required this.icon,
    required this.label,
    this.compact = false,
    super.key,
  });

  static const Map<String, String> labelToRoute = {
    'Home': '/home',
    'Entrenamientos': '/trainings',
    'Teams': '/teams',
  };

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute =  GoRouter.of(context).state.path;
    final buttonRoute = _NavButton.labelToRoute[widget.label] ?? '/${widget.label.toLowerCase()}';
    print(buttonRoute);
    final isActive = currentRoute == buttonRoute;

    Color bgColor;
    if (isActive) {
      bgColor = Colors.blue.shade700;
    } else if (_hovering) {
      bgColor = Colors.blue.shade800;
    } else {
      bgColor = Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: widget.compact ? Alignment.center : Alignment.centerLeft,
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: () {
          if (!isActive) {
            context.go(buttonRoute);
          }
        },
        child: widget.compact
            ? Icon(widget.icon, color: Colors.white)
            : Row(
          children: [
            Icon(widget.icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}

