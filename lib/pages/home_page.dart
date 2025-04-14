import 'package:flutter/material.dart';
import 'package:webgallery/components/web_image.dart';
import 'package:webgallery/core/gallery_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Gallery gallery = Gallery("New Gallery", []);
  GalleryManager galleryManager = GalleryManager();
  TextEditingController linkFieldEditingController = TextEditingController();
  TextEditingController galleryNameFieldEditingController =
      TextEditingController();

  void addImageLink(String link) {
    setState(() {
      gallery.urls.add(link);
    });
  }

  void loadGallery() async {
    try {
      var newGallery = await galleryManager.loadGallery();
      setState(() {
        gallery = newGallery;
      });
    } catch (e) {
      showMessage(e.toString());
    }
  }

  void saveGallery() async {
    try {
      await galleryManager.saveGallery(gallery);
    } catch (e) {
      showMessage(e.toString());
    }
  }

  void changeGalleryName(String newGalleryName) {
    setState(() {
      if(newGalleryName.isNotEmpty) {
        gallery.name = newGalleryName;
      } else {
        showMessage('Enter a non-empty name!');
      }
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(gallery.name),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) => buildGalleryNameEditModal(context));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => buildImageInsertModal(context));
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                saveGallery();
              },
              icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () {
                loadGallery();
              },
              icon: const Icon(Icons.upload)),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: gallery.urls.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WebImage(gallery.urls[index])
            ],
          );
        },
      ),
    );
  }

  Widget buildGalleryNameEditModal(BuildContext context) {
    return Column(children: [
      TextField(controller: galleryNameFieldEditingController),
      IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          changeGalleryName(galleryNameFieldEditingController.text);
          Navigator.pop(context);
        },
      )
    ]);
  }

  Widget buildImageInsertModal(BuildContext context) {
    return Column(children: [
      TextField(controller: linkFieldEditingController),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          addImageLink(linkFieldEditingController.text);
          linkFieldEditingController.text = '';
          showMessage('Image added into gallery!');
        },
      )
    ]);
  }
}
