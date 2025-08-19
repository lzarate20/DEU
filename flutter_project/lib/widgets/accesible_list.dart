import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibleList extends StatefulWidget {
  final List<Widget> buttons;
  final List<VoidCallback> onPressedCallbacks;
  final String semanticsLabel;

  const AccessibleList({
    super.key,
    required this.buttons,
    required this.onPressedCallbacks,
    required this.semanticsLabel,
  }) : assert(buttons.length == onPressedCallbacks.length,
  'Cada botón debe tener un callback');

  @override
  State<AccessibleList> createState() => _AccessibleListState();
}

class _AccessibleListState extends State<AccessibleList> {
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.buttons.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final index = _focusNodes.indexOf(node);


      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        final nextIndex = (index + 1).clamp(0, _focusNodes.length - 1);
        _focusNodes[nextIndex].requestFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        final prevIndex = (index - 1).clamp(0, _focusNodes.length - 1);
        _focusNodes[prevIndex].requestFocus();
        return KeyEventResult.handled;
      }

      else if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        widget.onPressedCallbacks[index].call();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.buttons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final node = _focusNodes[index];

          return Focus(
            focusNode: node,
            onKey: (_, event) => _handleKey(node, event),
            child: Builder(builder: (context) {
              final hasFocus = Focus.of(context).hasFocus;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: hasFocus
                        ? BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                        : BorderSide.none,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  backgroundColor: hasFocus
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : null,
                ),
                autofocus: false,
                onPressed: widget.onPressedCallbacks[index],
                child: widget.buttons[index],
              );
            }),
          );
        },
      ),
    );
  }
}

















