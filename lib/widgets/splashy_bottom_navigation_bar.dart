import 'package:flutter/material.dart';

class SplashyBottomNavigationBar extends StatelessWidget {
  final List<SplashyBottomNavigationBarItem> items;
  final Function(int) onTap;
  final int currentIndex;

  const SplashyBottomNavigationBar({
    required this.items,
    required this.onTap,
    this.currentIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final query = MediaQuery.of(context);

    EdgeInsets getPadding(bool selected, bool label) {
      if ((label && selected && (theme.showSelectedLabels ?? true)) ||
          (label && !selected && (theme.showUnselectedLabels ?? true))) {
        return const EdgeInsets.fromLTRB(12, 8, 12, 0);
      } else {
        return const EdgeInsets.fromLTRB(12, 16, 12, 16);
      }
    }

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black54, blurRadius: theme.elevation ?? 1)
      ]),
      child: BottomAppBar(
        elevation: 0,
        color: theme.backgroundColor,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final bool selected = index == currentIndex;
              return Expanded(
                child: InkResponse(
                  radius: (query.size.width - query.padding.horizontal) /
                      (items.length * 1.85),
                  splashColor: theme.selectedItemColor?.withOpacity(0.15),
                  highlightColor: Colors.transparent,
                  splashFactory: InkRipple.splashFactory,
                  onTap: () => onTap(index),
                  child: Padding(
                    padding: getPadding(selected, item.label != null),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconTheme(
                          child: selected
                              ? item.activeIcon ?? item.icon
                              : item.icon,
                          data: IconThemeData(
                            size: 24,
                            color: selected
                                ? theme.selectedItemColor
                                : theme.unselectedItemColor,
                          ),
                        ),
                        if (item.label != null &&
                            (((theme.showSelectedLabels ?? true) && selected) ||
                                ((theme.showUnselectedLabels ?? true) &&
                                    !selected)))
                          Text(
                            item.label!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: selected
                                  ? theme.selectedItemColor
                                  : theme.unselectedItemColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
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
