import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class InfoWidget extends StatelessWidget {
  final String info;
  const InfoWidget({Key key, @required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      color: Colors.green,
      child: Row(
        children: [
          Icon(LineIcons.info_circle, color: Colors.white),
          SizedBox(width: 10),
          Flexible(
              child: Text(
            info,
            style: TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ))
        ],
      ),
    );
  }
}
