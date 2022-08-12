import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sisfo_mobile/services/global_config.dart';

enum InfoWidgetStatus { info, warning, error }

class MessageWidget extends StatelessWidget {
  final String info;
  final InfoWidgetStatus status;
  final bool needBorderRadius;
  const MessageWidget({
    Key? key,
    required this.info,
    this.status = InfoWidgetStatus.info,
    this.needBorderRadius = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: needBorderRadius ? BorderRadius.circular(6) : null,
        color: status == InfoWidgetStatus.info
            ? Colors.green
            : status == InfoWidgetStatus.error
                ? Colors.red
                : Colors.yellow,
      ),
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Icon(LineIcons.infoCircle, color: Colors.white),
          SizedBox(width: 10),
          Flexible(
              child: Text(
            info,
            style: TextStyle(
                color: status == InfoWidgetStatus.warning
                    ? Colors.black
                    : Colors.white,
                fontSize: config.fontSizeH3),
          ))
        ],
      ),
    );
  }
}
