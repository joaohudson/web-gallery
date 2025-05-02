import 'package:flutter/material.dart';
import 'package:webgallery/components/removable_web_image.dart';
import 'package:webgallery/components/web_image.dart';
import 'package:webgallery/core/gallery_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Gallery gallery = Gallery("New Gallery", []);
  bool enableDelete = false;
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
      if (newGalleryName.isNotEmpty) {
        gallery.name = newGalleryName;
      } else {
        showMessage('Enter a non-empty name!');
      }
    });
  }

  void createNewEmptyGallery() {
    setState(() {
      gallery = Gallery('New Gallery', []);
    });
  }

  void toogleDeleteOperation() {
    setState(() {
      enableDelete = !enableDelete;
    });
  }

  void deleteImage(int index) {
    setState(() {
      if (enableDelete) {
        gallery.urls.removeAt(index);
        showMessage('Image deleted!');
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
        backgroundColor: enableDelete
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          gallery.name,
          overflow: TextOverflow.fade,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) => buildGalleryNameEditModal(context));
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: enableDelete
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.inversePrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            buildNewGalleryConfirmationModal(context));
                  },
                  icon: const Icon(Icons.new_label)),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => buildImageInsertModal(context));
                  },
                  icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () {
                    toogleDeleteOperation();
                  },
                  icon: Icon(
                      enableDelete ? Icons.cancel_outlined : Icons.delete)),
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
          )),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: gallery.urls.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
              width: MediaQuery.sizeOf(context).width - 40,
              height: MediaQuery.sizeOf(context).height - 120,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        onTap: () {
                          deleteImage(index);
                        },
                        child: enableDelete
                            ? RemovableWebImage(gallery.urls[index])
                            : WebImage(gallery.urls[index])),
                  ),
                ),
              )
            );
        },
      ),
    );
  }

  Widget buildGalleryNameEditModal(BuildContext context) {
    return Column(children: [
      TextField(
        textAlign: TextAlign.center,
        controller: galleryNameFieldEditingController,
        decoration:
            const InputDecoration(hintText: 'Enter a new gallery name:'),
      ),
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
      TextField(
          controller: linkFieldEditingController,
          decoration: const InputDecoration(
              hintText: 'Enter the link of the new image to gallery:')),
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

  Widget buildNewGalleryConfirmationModal(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Create a new gallery?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                createNewEmptyGallery();
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
      ]),
    );
  }
}
