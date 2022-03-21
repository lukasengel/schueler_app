import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class NewsTicker extends StatelessWidget {
  final String text;
  const NewsTicker(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PersistentHeader(
        widget: MarqueeText(
          alwaysScroll: true,
          speed: 40,
          text: TextSpan(
            text: text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        color: Theme.of(context).colorScheme.tertiary,
      ),
      alignment: Alignment.center,
      child: widget,
    );
  }

  @override
  double get maxExtent => 51.0;

  @override
  double get minExtent => 51.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
