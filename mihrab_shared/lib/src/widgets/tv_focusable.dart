import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A generic Focus wrapper that gives any child a gold-border glow
/// when focused via TV D-pad navigation.
class TvFocusable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSelect;
  final bool autofocus;
  final FocusNode? focusNode;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  const TvFocusable({
    super.key,
    required this.child,
    this.onSelect,
    this.autofocus = false,
    this.focusNode,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = EdgeInsets.zero,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (focused) {
        setState(() => _isFocused = focused);
        if (focused) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 200),
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          widget.onSelect?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onSelect,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            border: Border.all(
              width: _isFocused ? 3 : 0,
              color: _isFocused
                  ? Theme.of(context).colorScheme.inverseSurface
                  : Colors.transparent,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.inverseSurface.withValues(alpha: .3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
