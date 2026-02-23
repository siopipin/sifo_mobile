import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class CardMenu extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const CardMenu({
    Key? key,
    required this.iconPath,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 44, height: 44),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: config.fontPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
