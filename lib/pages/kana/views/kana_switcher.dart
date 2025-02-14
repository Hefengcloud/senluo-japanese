import 'package:flutter/material.dart';

import '../../../repos/gojuon/models/models.dart';

class KanaSwitcher extends StatelessWidget {
  final KanaType selectedType;
  final ValueChanged<KanaType> onChanged;

  const KanaSwitcher({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32, // 固定高度使按钮更小
      width: 180, // 适合三个按钮的宽度
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: .9),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            text: '平仮名',
            isSelected: selectedType == KanaType.hiragana,
            onTap: () => onChanged(KanaType.hiragana),
          ),
          _buildDivider(),
          _buildToggleButton(
            text: '片仮名',
            isSelected: selectedType == KanaType.katakana,
            onTap: () => onChanged(KanaType.katakana),
          ),
          _buildDivider(),
          _buildToggleButton(
            text: '全部',
            isSelected: selectedType == KanaType.all,
            onTap: () => onChanged(KanaType.all),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 16,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? Colors.indigo.shade700 : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
