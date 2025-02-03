import 'package:flutter/material.dart';

import '../constants/marketing_constants.dart';

class StoryBrandFrameworkView extends StatefulWidget {
  const StoryBrandFrameworkView({super.key});

  @override
  State<StoryBrandFrameworkView> createState() =>
      _StoryBrandFrameworkViewState();
}

class _StoryBrandFrameworkViewState extends State<StoryBrandFrameworkView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index < StoryBrandSevenPart.values.length - 1) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: StoryBrandSevenPart.values
          .map<Step>(
            (e) => Step(
              title: Text(e.name.toUpperCase()),
              content: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: e.questions.map<Text>((e) => Text(e)).toList(),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
