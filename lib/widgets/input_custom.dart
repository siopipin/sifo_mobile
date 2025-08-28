import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class InputCustom extends StatelessWidget {
  final TextEditingController ctrl;
  final String hind;
  final IconData icon;
  const InputCustom({
    Key? key,
    required this.ctrl,
    required this.hind,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 55,
      decoration: BoxDecoration(
          color: config.colorGrey, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(top: 10),
      child: TextField(
        controller: ctrl,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hind,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.black.withOpacity(0.8),
            )),
      ),
    );
  }
}
