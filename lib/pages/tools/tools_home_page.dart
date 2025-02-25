import 'package:flutter/material.dart';

class ToolsHomePage extends StatelessWidget {
  const ToolsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ツール"),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text("微信封面图"),
          )
        ],
      ),
    );
  }
}
