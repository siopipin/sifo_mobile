import 'package:flutter/material.dart';

class FotoProfileWidget extends StatefulWidget {
  FotoProfileWidget({Key key}) : super(key: key);

  @override
  State<FotoProfileWidget> createState() => _FotoProfileWidgetState();
}

class _FotoProfileWidgetState extends State<FotoProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(5)),
          child: Row(children: [
            Icon(
              Icons.camera,
              color: Colors.white,
              size: 15,
            ),
            Text(' Ganti', style: TextStyle(fontSize: 11, color: Colors.white))
          ]),
        )
      ],
    );
  }
}
