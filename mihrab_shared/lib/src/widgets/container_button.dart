import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../theme/app_text_styles.dart';

class ContainerButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? selectedColor;
  final Widget? icon;
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final Color? titleColor;
  final Color? subtitleColor;
  final bool isSelected;
  final Widget? child;
  final double? horizontalMargin;
  final double? verticalMargin;
  final double? horizontalPadding;
  final double? verticalPadding;
  final MainAxisAlignment? mainAxisAlignment;
  final bool isTitleCentered;
  final bool autofocus;

  const ContainerButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.selectedColor,
    this.icon,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.titleColor,
    this.subtitleColor,
    this.isSelected = false,
    this.child,
    this.horizontalMargin = 0.0,
    this.verticalMargin = 0.0,
    this.horizontalPadding = 12.0,
    this.verticalPadding = 12.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isTitleCentered = false,
    this.autofocus = false,
  });

  @override
  State<ContainerButton> createState() => _ContainerButtonState();
}

class _ContainerButtonState extends State<ContainerButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
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
          widget.onPressed?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(
            horizontal: widget.horizontalMargin ?? 0.0,
            vertical: widget.verticalMargin ?? 0.0,
          ),
          height: widget.height,
          width: widget.width,
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding ?? 12.0,
            vertical: widget.verticalPadding ?? 12.0,
          ),
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                theme.primaryColorLight.withValues(
                  alpha: widget.isSelected ? 0.5 : 0.2,
                ),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius ?? 12),
            ),
            border: Border.all(
              color: _isFocused
                  ? theme.colorScheme.inverseSurface
                  : widget.isSelected
                  ? theme.colorScheme.surface.withValues(alpha: 0.7)
                  : Colors.transparent,
              width: _isFocused ? 3 : 1,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: theme.colorScheme.inverseSurface.withValues(
                        alpha: .3,
                      ),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.isTitleCentered
                  ? MainAxisAlignment.center
                  : widget.mainAxisAlignment ?? MainAxisAlignment.start,
              children: [
                if (widget.isSelected)
                  Container(
                    width: 8,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color:
                          widget.selectedColor ??
                          theme.colorScheme.inverseSurface,
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.borderRadius ?? 12),
                      ),
                    ),
                  ),
                if (widget.isSelected) const Gap(8),
                if (widget.icon != null) widget.icon!,
                if (widget.icon != null && widget.title != null) const Gap(12),
                if (widget.title != null)
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: widget.isTitleCentered
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title!,
                          style:
                              widget.titleStyle ??
                              AppTextStyles.titleMedium(
                                color:
                                    widget.titleColor ??
                                    theme.colorScheme.inversePrimary,
                              ),
                        ),
                        if (widget.subtitle != null)
                          Text(
                            widget.subtitle!,
                            style: AppTextStyles.titleSmall(
                              color:
                                  widget.subtitleColor ??
                                  theme.colorScheme.inversePrimary,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (widget.child != null) widget.child!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
