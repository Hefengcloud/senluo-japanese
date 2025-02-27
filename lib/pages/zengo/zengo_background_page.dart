import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/helpers/image_helper.dart';
import 'package:unsplash_client/unsplash_client.dart';

class ZengoBackgroundPage extends StatefulWidget {
  const ZengoBackgroundPage({super.key});

  @override
  State<ZengoBackgroundPage> createState() => _ZengoBackgroundPageState();
}

class _ZengoBackgroundPageState extends State<ZengoBackgroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zen Picture'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(
          () {},
        ),
        child: const Icon(Icons.refresh),
      ),
      body: FutureBuilder<List<Photo>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final urls =
                snapshot.data!.map((e) => e.urls.regular.toString()).toList();
            return GridView.count(
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 2,
              childAspectRatio: 9 / 16,
              children:
                  urls.map<Widget>((url) => _buildImage(context, url)).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: unsplashClient.photos
            .random(
              query: "Japan",
              count: 4,
              orientation: PhotoOrientation.portrait,
            )
            .goAndGet(),
      ),
    );
  }

  _buildImage(BuildContext context, String url) => InkWell(
        onTap: () {
          Navigator.of(context).pop(url);
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
