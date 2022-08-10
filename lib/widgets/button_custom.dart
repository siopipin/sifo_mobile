import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final double width;
  final double height;
  final Color color;
  final bool useBorderRadius;
  final bool useElevation;
  final bool isPrimary;
  ButtonCustom({
    Key? key,
    required this.function,
    required this.text,
    this.width = double.infinity,
    this.height = 45,
    this.color = const Color(0xFFFFEB3B),
    this.useBorderRadius = true,
    this.useElevation = false,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Center(
        child: Text(
          text,
          style:
              TextStyle(color: isPrimary ? config.fontWhite : config.fontBlack),
        ),
      ),
      style: ElevatedButton.styleFrom(
          shape: useBorderRadius
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              : null,
          maximumSize: Size(width, height),
          primary: color,
          elevation: useElevation ? 0 : null),
    );
  }
}
