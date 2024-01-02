import 'package:flutter/material.dart';

class ItemCaptionTitle extends StatelessWidget {
  final String title;
  final Color bgColor;
  const ItemCaptionTitle({
    super.key,
    required this.title,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() => Container(
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      );
}
