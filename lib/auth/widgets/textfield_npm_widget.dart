import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class TextFieldNPMWidget extends StatelessWidget {
  final TextEditingController ctrl;
  const TextFieldNPMWidget({Key? key, required this.ctrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 60,
      decoration: BoxDecoration(
          color: config.colorGrey, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(top: 5),
      child: TextField(
        controller: ctrl,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Nomor Pokok Mahasiswa',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
            ),
            prefixIcon: Icon(
              LineIcons.user,
              color: Colors.black.withOpacity(0.8),
            )),
      ),
    );
  }
}
