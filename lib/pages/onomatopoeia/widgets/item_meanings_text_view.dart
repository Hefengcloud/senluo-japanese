import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_common/senluo_common.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

class ItemMeaningsTextView extends StatelessWidget {
  final Onomatopoeia item;
  const ItemMeaningsTextView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(kTitleJpMeaning),
          ..._buildMeanings(item.meanings['jp']!),
          const Gap(16),
          _buildTitle(kTitleZhMeaning),
          ..._buildMeanings(item.meanings['zh']!),
          const Gap(16),
          _buildTitle(kTitleEnMeaning),
          ..._buildMeanings(item.meanings['en']!),
        ],
      ),
    );
  }

  _buildMeanings(List<String> meanings) =>
      meanings.map((e) => Text(e)).toList();

  _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
