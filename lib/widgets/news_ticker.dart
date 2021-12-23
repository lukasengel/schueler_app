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
          text: TextSpan(text: text),
        ),
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        color: Theme.of(context).cardColor,
      ),
      alignment: Alignment.center,
      child: widget,
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
