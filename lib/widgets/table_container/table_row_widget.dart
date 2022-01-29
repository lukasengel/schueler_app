import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/substitution_table.dart';

class TableRowWidget extends StatelessWidget {
  final Function(String) lookup;
  final SubstitutionTableRow row;

  const TableRowWidget({required this.row, required this.lookup, Key? key})
      : super(key: key);

  String insertLinefeed(String data) {
    return data.replaceFirst(('('), "\n\r(");
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyText1!;

    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              row.course,
              style: style.copyWith(fontWeight: FontWeight.w600),
            ),
            flex: 7,
          ),
          Expanded(
            child: Text(
              row.period,
              style: style,
            ),
            flex: 5,
          ),
          Expanded(
            child: CupertinoButton(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              onPressed: () => lookup(row.absent.substring(0, 3)),
              child: Text(
                row.absent,
                style: style,
              ),
            ),
            flex: 8,
          ),
          Expanded(
            child: CupertinoButton(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              onPressed: () => lookup(row.substitute.substring(0, 3)),
              child: Text(
                insertLinefeed(row.substitute),
                textAlign: TextAlign.center,
                style: style,
              ),
            ),
            flex: 8,
          ),
          Expanded(
            child: Text(
              row.room,
              style: style,
            ),
            flex: 7,
          ),
          Expanded(
            child: Text(
              row.info,
              style: style,
            ),
            flex: 15,
          ),
        ],
      ),
    );
  }
}

class TableHeaderRow extends StatelessWidget {
  final SubstitutionTableRow header;

  const TableHeaderRow({required this.header, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontWeight: FontWeight.bold);

    return Container(
      constraints: const BoxConstraints(minHeight: 20),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(header.course, style: style),
            flex: 7,
          ),
          Expanded(
            child: Text(header.period, style: style),
            flex: 5,
          ),
          Expanded(
            child: Text(header.absent, style: style),
            flex: 8,
          ),
          Expanded(
            child: Text(header.substitute, style: style),
            flex: 8,
          ),
          Expanded(
            child: Text(header.room, style: style),
            flex: 7,
          ),
          Expanded(
            child: Text(header.info, style: style),
            flex: 15,
          ),
        ],
      ),
    );
  }
}
