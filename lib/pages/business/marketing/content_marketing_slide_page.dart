import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../repos/business/business_repository.dart';
import '../../../repos/business/models/models.dart';

class ContentMarketingSlidePage extends StatelessWidget {
  final BusinessRepository repo;
  final GlobalKey _globalKey = GlobalKey();

  ContentMarketingSlidePage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Marketing'),
      ),
      body: FutureBuilder(
        future: repo.loadContentMarketingSteps(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final steps = snapshot.data!;
            return RepaintBoundary(
              key: _globalKey,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: PageView(
                  children: steps
                      .mapIndexed<Widget>(
                        (idx, e) => _buildStep(context, e, idx, steps.length),
                      )
                      .toList(),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _buildStep(
    BuildContext context,
    ContentMarketingStep step,
    int index,
    int total,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFff2442),
          width: 8,
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'content marketing (${index + 1} / $total)'.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.grey),
          ),
          const Gap(8),
          AutoSizeText(
            step.step,
            style: theme.textTheme.displayLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          Text(
            step.desc,
            style: theme.textTheme.headlineLarge,
          ),
          const Gap(16),
          Text(
            step.details.map((e) => "- $e").join('\n'),
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
