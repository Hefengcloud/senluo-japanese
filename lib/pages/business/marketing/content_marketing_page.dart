import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

const _steps = [
  Tuple2(
    'Goal Setting',
    'What do you want to achieve with this content-marketing compaign?',
  ),
  Tuple2(
    'Audience Mapping',
    'Who are your customers and what are their anxieties and desires?',
  ),
  Tuple2(
    'Content Ideation & Planning',
    'What is the overall content theme and what is the content roadmap?',
  ),
  Tuple2(
    'Content Creation',
    'Who creates the content and when?',
  ),
  Tuple2(
    'Content Distribution',
    'Where do you want to distribute the content assets?',
  ),
  Tuple2(
    'Content Amplification',
    'How do you plan to leverage content assets and interact with customers',
  ),
  Tuple2(
    'Content-Marketing Evaluation',
    'How successful is your content-marketing campaign?',
  ),
  Tuple2(
    'Content-Marketing Improvement',
    'How do you improve existing content marketing?',
  ),
];

class ContentMarketingPage extends StatelessWidget {
  const ContentMarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Marketing')),
      body: ListView(
        children: [
          _buildGoalSettingTitle(),
          _buildAudienceMappingTitle(),
          _buildContentIdeationAndPlanningTitle(),
          _buildContentCreationTitle(),
          _buildContentDistributionTitle(),
          _buildContentAmplificationTitle(),
          _buildContentMarketingEvaluationTitle(),
          _buildContentMarketingImprovementTitle(),
        ],
      ),
    );
  }

  ExpansionTile _buildGoalSettingTitle() {
    return ExpansionTile(
      title: Text(_steps[0].item1.toUpperCase()),
      subtitle: Text(_steps[0].item2),
      children: [
        ListTile(
          leading: const Icon(Icons.check_outlined),
          title: const Text('Sales-growth objective'),
          subtitle: Text(const [
            'Lead Generation',
            'sales closing',
            'cross-sell',
            'up-sell',
            'sales referral'
          ].join(', ')),
        ),
        ListTile(
          leading: const Icon(Icons.check_outlined),
          title: const Text('Brand-building objective'),
          subtitle: Text(const [
            'brand awareness',
            'brand association',
            'brand loyalty/advocacy'
          ].join(', ')),
        ),
      ],
    );
  }

  _buildAudienceMappingTitle() {
    return ExpansionTile(
      title: Text(_steps[1].item1.toUpperCase()),
      subtitle: Text(_steps[1].item2),
      children: const [
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Customer profiling and persona'),
        ),
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Customer anxieties and desires'),
        ),
      ],
    );
  }

  _buildContentIdeationAndPlanningTitle() {
    return ExpansionTile(
      title: Text(_steps[2].item1.toUpperCase()),
      subtitle: Text(_steps[2].item2),
      children: const [
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Content theme'),
        ),
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Content formats and mix'),
        ),
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Content storyline and calendar'),
        ),
      ],
    );
  }

  _buildContentCreationTitle() {
    return ExpansionTile(
      title: Text(_steps[3].item1.toUpperCase()),
      subtitle: Text(_steps[3].item2),
      children: const [
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Content creators: in-house or agencies'),
        ),
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Content production schedule'),
        ),
      ],
    );
  }

  _buildContentDistributionTitle() {
    return ExpansionTile(
      title: Text(_steps[4].item1.toUpperCase()),
      subtitle: Text(_steps[4].item2),
      children: const [
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Owned channel'),
        ),
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Paied channel'),
        ),
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Earned channel'),
        ),
      ],
    );
  }

  _buildContentAmplificationTitle() {
    return ExpansionTile(
      title: Text(_steps[5].item1.toUpperCase()),
      subtitle: Text(_steps[5].item2),
      children: const [
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Creating conversation around content'),
        ),
        ListTile(
          leading: Icon(Icons.check_outlined),
          title: Text('Use of buzzers and influencers'),
        ),
      ],
    );
  }

  _buildContentMarketingEvaluationTitle() {
    return ExpansionTile(
      title: Text(_steps[6].item1.toUpperCase()),
      subtitle: Text(_steps[6].item2),
      children: const [
        ListTile(
          leading: Icon(Icons.arrow_right_outlined),
          title: Text('Content-marketing matrics'),
        ),
        ListTile(
          leading: Icon(Icons.arrow_right_outlined),
          title: Text('Overall objective achievements'),
        ),
      ],
    );
  }

  _buildContentMarketingImprovementTitle() {
    return ExpansionTile(
      title: Text(_steps[7].item1.toUpperCase()),
      subtitle: Text(_steps[7].item2),
      children: const [
        ListTile(
          leading: Icon(Icons.arrow_right_outlined),
          title: Text('Content theme change'),
        ),
        ListTile(
          leading: Icon(Icons.arrow_right_outlined),
          title: Text('Content improvement'),
        ),
        ListTile(
          leading: Icon(Icons.arrow_right_outlined),
          title: Text('Content distribution and amplification improvement'),
        ),
      ],
    );
  }
}
