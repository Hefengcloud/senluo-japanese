import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:senluo_japanese_cms/common/helpers/url_helper.dart';
import 'package:senluo_japanese_cms/pages/business/constants/marketing_constants.dart';
import 'package:senluo_japanese_cms/pages/business/widgets/story_brand_framework_view.dart';
import 'package:senluo_japanese_cms/pages/business/widgets/social_media_entry_view.dart';
import 'package:senluo_japanese_cms/widgets/entry_view.dart';
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
        title: Text('Marketing'),
      ),
      body: _buildContent(context),
    );
  }

  _buildContent(BuildContext context) {
    return ListView(
      children: [
        const TitleView(title: 'Customer Persona'),
        _buildCustomerPersona(context),
        const TitleView(title: 'Social Media'),
        _buildSocialMedia(context),

        // Tools
        const TitleView(title: 'Tools'),
        const ListTile(
          title: Text('The StoryBrand Seven-Part Framework'),
        ),
      ],
    );
  }

  _buildCustomerPersona(BuildContext context) => Wrap(
        children: CustomerPersona.values
            .map<EntryView>((e) => EntryView(title: e.name))
            .toList(),
      );

  _buildSocialMedia(BuildContext context) {
    return Wrap(
      children: SocialMedia.values
          .map((e) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SocialMediaEntryView(
                  socialMedia: e,
                  onTap: () {
                    UrlHelper.launchUrl(e.url);
                  },
                ),
              ))
          .toList(),
    );
  }

  _buildStoryBrandFramework() {
    return const Card(
      child: StoryBrandFrameworkView(),
    );
  }
}
