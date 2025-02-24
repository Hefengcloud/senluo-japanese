import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/business/constants/business_constants.dart';

class LeadershipPage extends StatelessWidget {
  const LeadershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return ListView(
      children: [
        _buildTextPanel(
          context,
          const Color(0xccDE6327),
          'Vision',
          BusinessConstants.vision,
        ),
        _buildTextPanel(
          context,
          const Color(0xcc7CA142),
          'Mission',
          BusinessConstants.mission,
        ),
        _buildValuePanel(context, const Color(0xcc2F99CD), ['利他'])
      ]
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: e,
              ))
          .toList(),
    );
  }

  _buildTextPanel(BuildContext context, color, String title, String content) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white54),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  _buildValuePanel(BuildContext context, Color color, List<String> values) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Values',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white54),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: BusinessConstants.values
                .map(
                  (value) => Container(
                    margin: const EdgeInsets.only(bottom: 8, right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${value.item1} / ${value.item2}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
