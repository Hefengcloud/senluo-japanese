import 'package:flutter/material.dart';

class KanaSwitcher extends StatelessWidget {
  final bool isHiragana;
  final ValueChanged<bool> onChanged;

  const KanaSwitcher({
    super.key,
    required this.isHiragana,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 让Row更紧凑
        children: [
          _buildToggleButton(
            text: '平仮名',
            isSelected: isHiragana,
            onTap: () => onChanged(true),
          ),
          const SizedBox(width: 1),
          _buildToggleButton(
            text: '片仮名',
            isSelected: !isHiragana,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: isSelected ? Colors.indigo.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8), // 减小垂直内边距
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14, // 减小字体大小
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? Colors.indigo.shade700 : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
