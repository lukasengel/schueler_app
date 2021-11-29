import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsTile extends StatelessWidget {
  final String label;
  final Icon icon;
  final Function() onTap;

  SettingsTile(
      {required this.label, required this.icon, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: context.theme.cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Row(
              children: [
                Expanded(child: icon),
                Expanded(flex: 8, child: Text(label)),
                const Expanded(
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsSwitch extends StatefulWidget {
  final Future<bool> Function(bool) onChanged;
  final String label;
  bool value;

  SettingsSwitch({
    required this.label,
    required this.onChanged,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.theme.cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).primaryColor,
              value: widget.value,
              onChanged: (val) async {
                setState(() => widget.value = val);
                final input = await widget.onChanged(val);
                setState(() => widget.value = input);
              })
        ],
      ),
    );
  }
}

// class SettingsFilters extends StatefulWidget {
//   final List<String> filters;
//   final Future<void> Function(List<String>) onChanged;

//   SettingsFilters({required this.onChanged, required this.filters, Key? key})
//       : super(key: key);

//   @override
//   State<SettingsFilters> createState() => _SettingsFiltersState();
// }

// class _SettingsFiltersState extends State<SettingsFilters> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//           child: Text(
//             "choose_grade".tr,
//             style: Get.textTheme.bodyText2,
//           ),
//         ),
//         ...List.generate(8, (index) {
//           final grade = (index + 5).toString();
//           return SettingsSwitch(
//             label: "$grade. Klasse",
//             value: !widget.filters.contains(grade),
//             onChanged: (val) async {
//               if (widget.filters.contains(grade)) {
//                 widget.filters.remove(grade);
//               } else {
//                 widget.filters.add(grade);
//               }
//               widget.onChanged(widget.filters);
//               return !widget.filters.contains(grade);
//             },
//           );
//         }),
//       ],
//     );
//   }
// }
