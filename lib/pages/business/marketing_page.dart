import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/business/constants/marketing_constants.dart';
import 'package:senluo_japanese_cms/pages/business/marketing/content_marketing_page.dart';
import 'package:senluo_japanese_cms/pages/business/marketing/story_brand_framework_page.dart';

import '../../repos/business/business_repository.dart';

class MarketingPage extends StatelessWidget {
  const MarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Customer Persona
        ExpansionTile(
          title: const Text('Customer Persona'),
          children: CustomerPersona.values
              .map<ListTile>(
                (e) => ListTile(
                  leading: const Icon(Icons.arrow_right_outlined),
                  title: Text(e.name),
                ),
              )
              .toList(),
        ),
        ExpansionTile(
          title: const Text('Social Media'),
          children: [
            ExpansionTile(
              title: const Text("日系生活家"),
              children: kEverjapanChannles
                  .map<ListTile>((e) => ListTile(title: Text(e.name)))
                  .toList(),
            ),
          ],
        ),
        // Social Media
        const SizedBox(height: 8),

        ExpansionTile(
          title: const Text('Tools'),
          children: [
            ListTile(
              title: const Text('The StoryBrand Seven-Part Framework'),
              leading: const Icon(Icons.arrow_right_outlined),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const StoryBrandFrameworkPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Step-by-Step Content Marketing'),
              leading: const Icon(Icons.arrow_right_outlined),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ContentMarketingPage(
                      repo: context.read<BusinessRepository>(),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
