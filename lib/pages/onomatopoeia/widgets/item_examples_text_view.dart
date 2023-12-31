import 'package:flutter/material.dart';

import '../../../repos/onomatopoeia/models/onomatopoeia_models.dart';

class ItemExamplesTextView extends StatefulWidget {
  final Function(List<Example>) onExamplesSelected;

  final List<Example> examples;
  const ItemExamplesTextView({
    super.key,
    required this.examples,
    required this.onExamplesSelected,
  });

  @override
  State<ItemExamplesTextView> createState() => _ItemExamplesTextViewState();
}

class _ItemExamplesTextViewState extends State<ItemExamplesTextView> {
  List<Example> _examples = [];

  @override
  Widget build(BuildContext context) {
    return _buildExamplesText(context);
  }

  _buildExamplesText(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.examples
          .map((e) => ListTile(
                title: Text(e['jp'] ?? ''),
                subtitle: Text(e['en'] ?? ''),
                leading: _examples.contains(e) ? const Icon(Icons.check) : null,
                // leading: const Icon(Icons.check),
                onTap: () {
                  final examples = List<Example>.from(_examples);
                  if (examples.contains(e)) {
                    examples.remove(e);
                  } else {
                    examples.add(e);
                  }
                  setState(() {
                    _examples = examples;
                  });
                  widget.onExamplesSelected(_examples);
                },
              ))
          .toList(),
    );
  }
}
