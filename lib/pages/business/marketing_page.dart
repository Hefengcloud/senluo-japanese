import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/business/business_repository.dart';
import 'marketing/content_marketing_page.dart';
import 'marketing/story_brand_framework_page.dart';

class MarketingPage extends StatelessWidget {
  const MarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Content Marketing'),
          trailing: const Icon(Icons.arrow_forward_outlined),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ContentMarketingPage(
                  repo: context.read<BusinessRepository>(),
                ),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('The StoryBrand Seven-Part Framework'),
          trailing: const Icon(Icons.arrow_forward_outlined),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const StoryBrandFrameworkPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
