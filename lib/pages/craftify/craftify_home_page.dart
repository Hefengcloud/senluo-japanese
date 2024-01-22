import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/craftify/dialogs/craftify_image_page.dart';
import 'package:tuple/tuple.dart';

class CraftifyHomePage extends StatelessWidget {
  const CraftifyHomePage({super.key});

  static const _menus = [
    Tuple2("生成图片", "image"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Craftify'),
      ),
      body: GridView.count(
        crossAxisCount: 6,
        childAspectRatio: 2,
        children: [
          InkWell(
            child: Card(
              child: Align(
                alignment: Alignment.center,
                child: Text('A vs B'),
              ),
            ),
            onTap: () => _showDialog(context, CraftifyImageDialog()),
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context, Widget content) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: SizedBox(
            width: 800,
            child: content,
          ),
          title: const Text('A vs B'),
        ),
      );
}
