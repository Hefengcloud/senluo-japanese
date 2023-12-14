import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GrammarAddingView extends StatefulWidget {
  const GrammarAddingView({super.key});

  @override
  State<GrammarAddingView> createState() => _GrammarAddingViewState();
}

class _GrammarAddingViewState extends State<GrammarAddingView> {
  int _index = 0;

  final _steps = <Step>[
    Step(
      title: const Text('Japanese Meaning'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(
          maxLines: null,
        ),
      ),
    ),
    Step(
      title: const Text('Chinese Meaning'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('English Meaning'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('Conjugation'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('Explanation'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('Examples'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const Text('Content for Step 2'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final stepCount = _steps.length;

    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        } else {
          Navigator.of(context).pop();
        }
      },
      onStepContinue: () {
        if (_index < stepCount - 1) {
          setState(() {
            _index += 1;
          });
        } else {
          // Add the new grammar piece
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: _steps,
    );
  }
}
