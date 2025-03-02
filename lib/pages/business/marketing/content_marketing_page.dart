import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/business/marketing/content_marketing_slide_page.dart';
import 'package:senluo_japanese_cms/repos/business/business_repository.dart';

import '../../../common/constants/constants.dart';

class ContentMarketingPage extends StatelessWidget {
  final BusinessRepository repo;

  const ContentMarketingPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Marketing Steps'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ContentMarketingSlidePage(repo: repo),
              ),
            ),
            icon: const Icon(Icons.animation_outlined),
          )
        ],
      ),
      body: FutureBuilder(
        future: repo.loadContentMarketingSteps(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final steps = snapshot.data!;
            return ListView(
              children: steps
                  .mapIndexed(
                    (idx, e) => ExpansionTile(
                      leading: Text("${idx + 1}",
                          style: Theme.of(context).textTheme.bodyLarge),
                      title: Text(
                        e.step,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(e.desc),
                      children: e.details
                          .mapIndexed<ListTile>(
                            (idx, d) => ListTile(
                              leading: Text(maruNumbers[idx]),
                              title: Text(d),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
