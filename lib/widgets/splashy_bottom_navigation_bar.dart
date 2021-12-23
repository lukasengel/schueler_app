import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashyBottomNavigationBar extends StatelessWidget {
  final List<SplashyBottomNavigationBarItem> items;
  final Function(int)? onTap;
  final bool hapticFeedback;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final TextStyle? selectedLabelStyle;
  final IconThemeData? selectedIconTheme;
  final Color? unselectedItemColor;
  final TextStyle? unselectedLabelStyle;
  final IconThemeData? unselectedIconTheme;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final int? currentIndex;
  final double? elevation;

  const SplashyBottomNavigationBar({
    required this.items,
    required this.onTap,
    this.elevation,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.currentIndex = 0,
    this.hapticFeedback = true,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme.copyWith(
          elevation: elevation,
          backgroundColor: backgroundColor,
          selectedIconTheme: selectedIconTheme,
          selectedItemColor: selectedItemColor,
          selectedLabelStyle: selectedLabelStyle,
          showSelectedLabels: showSelectedLabels,
          unselectedIconTheme: unselectedIconTheme,
          unselectedItemColor: unselectedItemColor,
          unselectedLabelStyle: unselectedLabelStyle,
          showUnselectedLabels: showUnselectedLabels,
        );

    TextStyle labelStyle(bool selected) {
      if (theme.selectedLabelStyle != null) {
        return theme.selectedLabelStyle!.copyWith(
          fontSize: 12,
          color: selected ? theme.selectedItemColor : theme.unselectedItemColor,
        );
      } else {
        return TextStyle(
          fontSize: 12,
          color: selected ? theme.selectedItemColor : theme.unselectedItemColor,
        );
      }
    }

    EdgeInsets padding(bool selected, bool label) {
      if ((label && selected && (theme.showSelectedLabels ?? true)) ||
          (label && !selected && (theme.showUnselectedLabels ?? true))) {
        return const EdgeInsets.fromLTRB(12, 8, 12, 0);
      } else {
        return const EdgeInsets.fromLTRB(12, 16, 12, 16);
      }
    }

    IconThemeData iconTheme(bool selected) {
      if (theme.selectedIconTheme != null) {
        return theme.selectedIconTheme!.copyWith(
          size: 24,
          color: selected ? theme.selectedItemColor : theme.unselectedItemColor,
        );
      } else {
        return IconThemeData(
          size: 24,
          color: selected ? theme.selectedItemColor : theme.unselectedItemColor,
        );
      }
    }

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: theme.elevation ?? 1,
        )
      ]),
      child: BottomAppBar(
        elevation: 0,
        color: theme.backgroundColor,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(
              items.length,
              (index) {
                final item = items[index];
                final query = MediaQuery.of(context);
                final bool selected = index == currentIndex;
                return Expanded(
                  child: InkResponse(
                    radius: (query.size.width - query.padding.horizontal) /
                        (items.length * 1.85),
                    splashColor: theme.selectedItemColor?.withOpacity(0.15),
                    highlightColor: Colors.transparent,
                    splashFactory: InkRipple.splashFactory,
                    onTap: onTap != null
                        ? () {
                            if (hapticFeedback) {
                              HapticFeedback.lightImpact();
                            }
                            onTap!(index);
                          }
                        : null,
                    child: Padding(
                      padding: padding(selected, item.label != null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconTheme(
                            child: selected
                                ? item.activeIcon ?? item.icon
                                : item.icon,
                            data: iconTheme(selected),
                          ),
                          if (item.label != null &&
                              (((theme.showSelectedLabels ?? true) &&
                                      selected) ||
                                  ((theme.showUnselectedLabels ?? true) &&
                                      !selected)))
                            Text(
                              item.label!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: labelStyle(selected),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SplashyBottomNavigationBarItem {
  final Widget icon;
  final Widget? activeIcon;
  final Color? backgroundColor;
  final String? label;

  SplashyBottomNavigationBarItem({
    required this.icon,
    this.activeIcon,
    this.backgroundColor,
    this.label,
  });
}
