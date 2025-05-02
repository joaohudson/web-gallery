import 'package:flutter/material.dart';
import 'package:webgallery/components/web_image.dart';
import 'package:webgallery/core/gallery_manager.dart';

class SingleImagePage extends StatelessWidget {
  final int index;
  final Gallery gallery;
  const SingleImagePage({required this.gallery, required this.index, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${gallery.name} - $index'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: InteractiveViewer(
          minScale: 0.5,
          maxScale: 8.0,
          child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: WebImage(gallery.urls[index]),
                ),
              ))),
    );
  }
}
