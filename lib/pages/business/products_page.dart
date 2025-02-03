import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:senluo_japanese_cms/widgets/entry_view.dart';
import 'package:senluo_japanese_cms/widgets/title_view.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Device.get().isPhone
        ? _buildMobileBody(context)
        : _buildContent(context);
  }

  _buildMobileBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: _buildContent(context),
    );
  }

  _buildContent(BuildContext context) {
    return ListView(
      children: [
        const TitleView(title: 'Apps'),
        _buildApps(context),
        const TitleView(title: 'E-books'),
        const TitleView(title: 'Online Courses'),
        const TitleView(title: 'Paid Newsletter'),
      ]
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(8),
              child: e,
            ),
          )
          .toList(),
    );
  }

  _buildApps(BuildContext context) => Wrap(
        children: [
          '五十音',
          '日语语法速查',
        ]
            .map(
              (e) => GestureDetector(
                onTap: () {},
                child: EntryView(title: e),
              ),
            )
            .toList(),
      );
}
