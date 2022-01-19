import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CopyrightNotice extends StatelessWidget {
  const CopyrightNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style1 = TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontFamily: "Montserrat",
      letterSpacing: 1,
    );

    const style2 = TextStyle(
      color: Colors.grey,
      fontSize: 20,
      fontFamily: "Montserrat",
      letterSpacing: 1,
    );

    const spacer1 = SizedBox(height: 5);
    const spacer2 = SizedBox(height: 10);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            "logo_artist".tr,
            style: style1,
            overflow: TextOverflow.ellipsis,
          ),
          spacer1,
          Text(
            "nika".tr.tr.toUpperCase(),
            style: style2,
            overflow: TextOverflow.ellipsis,
          ),
          spacer2,
          Text(
            "developer".tr,
            style: style1,
            overflow: TextOverflow.ellipsis,
          ),
          spacer1,
          Text(
            "lukas".tr.toUpperCase(),
            style: style2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 40),
          Text(
            "license".tr.toUpperCase(),
            style: style1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
