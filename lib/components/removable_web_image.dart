import 'package:flutter/material.dart';
import 'package:webgallery/components/web_image.dart';

class RemovableWebImage extends StatelessWidget {
  final String url;
  const RemovableWebImage(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      WebImage(url),
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.4), // Película semi-transparente
        ),
      ),
      const Icon(
        Icons.delete,
        size: 40,
      )
    ]);
  }
}
