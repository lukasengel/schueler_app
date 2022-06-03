import 'package:flutter/material.dart';

class ArticleContent extends StatelessWidget {
  final bool header;
  final String text;
  const ArticleContent(this.text, this.header, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: header ? FontWeight.w500 : null,
            ),
      ),
    );
  }
}
