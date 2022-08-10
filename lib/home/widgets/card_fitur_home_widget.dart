import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class CardMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  const CardMenu({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 100,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(color: Color(0x148b8a8a), offset: Offset(0, 3), blurRadius: 6)
      ]),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              icon,
              size: 35,
            ),
            Text(
              label,
              style: TextStyle(
                  color: config.fontPrimary.withOpacity(0.5), fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
