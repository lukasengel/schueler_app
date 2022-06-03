import 'package:flutter/material.dart';

class ArticleHeader extends StatelessWidget {
  final String text;
  const ArticleHeader(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
