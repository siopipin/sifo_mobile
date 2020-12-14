import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SomeError extends StatelessWidget {
  const SomeError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              LineIcons.warning,
              size: 30,
            ),
            Text(
              'Something was \nwrong, reload!',
              style: TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
