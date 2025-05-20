import 'package:flutter/material.dart';
import 'package:webgallery/components/web_image.dart';
import 'package:webgallery/core/gallery_manager.dart';

class SingleImagePage extends StatefulWidget {
  final int index;
  final Gallery gallery;
  const SingleImagePage(
      {required this.gallery, required this.index, super.key});
  @override
  State<SingleImagePage> createState() => _SingleImagePageState();
}

class _SingleImagePageState extends State<SingleImagePage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  bool inFirstImage() {
    return currentIndex == 0;
  }

  bool inLastImage() {
    return currentIndex == widget.gallery.urls.length - 1;
  }

  void nextPage() {
    setState(() {
      if (!inLastImage()) {
        currentIndex++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (!inFirstImage()) {
        currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.gallery.name} - ${currentIndex + 1} / ${widget.gallery.urls.length}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 8.0,
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Center(
            child: Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: WebImage(widget.gallery.urls[currentIndex]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: inFirstImage() ? null : previousPage,
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: inLastImage() ? null : nextPage,
              icon: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
