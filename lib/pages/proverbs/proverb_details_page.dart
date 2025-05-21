import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/proverbs/proverb_display_page.dart';
import 'package:senluo_proverb/senluo_proverb.dart';

class ProverbDetailsPage extends StatelessWidget {
  final ProverbItem proverb;

  const ProverbDetailsPage({super.key, required this.proverb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ことわざ"),
      ),
      body: ProverbDetailView(proverb: proverb),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () {},
            child: const Text('← 前'),
          ),
          const Gap(16),
          OutlinedButton(
            onPressed: () {},
            child: const Text('次 →'),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _displayProverb(context),
            icon: const Icon(Icons.image_outlined),
          ),
        ],
      ),
    );
  }

  _displayProverb(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProverbDisplayPage(item: proverb),
      ),
    );
  }
}
