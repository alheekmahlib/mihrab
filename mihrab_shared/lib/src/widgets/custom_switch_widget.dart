import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../theme/app_text_styles.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;
  final double width;
  final double height;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.width = 61,
    this.height = 31,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final trackColor = value
        ? (activeColor ?? context.theme.primaryColorLight)
        : (inactiveTrackColor ?? context.theme.colorScheme.primaryContainer);
    const thumbPadding = 3.0;
    final thumbWidth = 40.0;
    final maxOffset = width - thumbWidth - (thumbPadding * 2);
    final thumbAtEnd = isRtl ? !value : value;

    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: trackColor,
        ),
        padding: const EdgeInsets.all(thumbPadding),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: thumbAtEnd ? maxOffset : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: thumbWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: thumbColor ?? context.theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitchListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final Color? activeColor;
  final Color? inactiveTrackColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? contentMargin;

  const CustomSwitchListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.leading,
    this.activeColor,
    this.inactiveTrackColor,
    this.contentPadding,
    this.contentMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
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
          onChanged?.call(!value);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return GestureDetector(
            onTap: () => onChanged?.call(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: contentMargin ?? EdgeInsets.zero,
              decoration: BoxDecoration(
                color: value
                    ? Theme.of(context).primaryColorLight.withValues(alpha: .1)
                    : Theme.of(
                        context,
                      ).primaryColorLight.withValues(alpha: .15),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  width: isFocused ? 3 : 1,
                  color: isFocused
                      ? Theme.of(context).colorScheme.inverseSurface
                      : !value
                      ? Colors.transparent
                      : Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: .7),
                ),
                boxShadow: isFocused
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
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    const Gap(12),
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.titleMedium().copyWith(
                              height: 2,
                            ),
                          ),
                          if (subtitle != null)
                            Text(subtitle!, style: AppTextStyles.titleSmall()),
                        ],
                      ),
                    ),
                    CustomSwitch(
                      value: value,
                      onChanged: onChanged,
                      activeColor: activeColor,
                      inactiveTrackColor: inactiveTrackColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
