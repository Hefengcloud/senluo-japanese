import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:senluo_japanese_cms/common/helpers/url_helper.dart';
import 'package:senluo_japanese_cms/pages/business/constants/marketing_constants.dart';
import 'package:senluo_japanese_cms/pages/business/story_brand_framework_page.dart';
import 'package:senluo_japanese_cms/widgets/title_view.dart';

class MarketingPage extends StatelessWidget {
  const MarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Device.get().isPhone ? _buildBody(context) : _buildContent(context);
  }

  _buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketing'),
      ),
      body: _buildContent(context),
    );
  }

  _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          // Customer Persona
          const TitleView(title: 'Customer Persona'),
          ..._buildCustomerPersona(context),
          const SizedBox(height: 8),

          // Social Media
          const TitleView(title: 'Social Media'),
          _buildSocialMedia(context),
          const SizedBox(height: 8),

          // Tools
          const TitleView(title: 'Tools'),
          ListTile(
            title: const Text('The StoryBrand Seven-Part Framework'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              if (Device.get().isPhone) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const StoryBrandFrameworkPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Customer persona
  _buildCustomerPersona(BuildContext context) => CustomerPersona.values
      .map<ListTile>((e) => ListTile(
            title: Text(e.name),
            trailing: const Icon(Icons.arrow_forward),
          ))
      .toList();

  // Social media entries
  _buildSocialMedia(BuildContext context) {
    return Wrap(
      children: SocialMedia.values
          .map((e) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    UrlHelper.launchUrl(e.url);
                  },
                  label: Text(e.name),
                ),
              ))
          .toList(),
    );
  }
}
