import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_bunpo/senluo_bunpo.dart';

class GrammarSlidePage extends StatelessWidget {
  final GrammarItem item;

  const GrammarSlidePage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammar'),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return _Title(item.name);
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.kleeOne(
                color: Colors.white,
                fontSize: 72,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
