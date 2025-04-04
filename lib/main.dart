import 'package:flutter/material.dart';
import 'package:webgallery/core/gallery_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Empty'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Gallery gallery = Gallery("Empty", []);
  GalleryManager galleryManager = GalleryManager();
  TextEditingController linkFieldEditingController = TextEditingController();

  void addImageLink(String link) {
    setState(() {
      gallery.urls.add(link);
    });
  }

  void loadGallery() async {
    var newGallery = await galleryManager.loadGallery();
    setState(() {
      gallery = newGallery;
      print(gallery.urls);
    });
  }

  void saveGallery() {
    galleryManager.saveGallery(gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                saveGallery();
              },
              icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () {
                loadGallery();
              },
              icon: const Icon(Icons.upload))
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: gallery.urls.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                gallery.urls[index],
                fit: BoxFit.none,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => buildImageInsertModal(context));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildImageInsertModal(BuildContext context) {
    return Column(children: [
      TextField(controller: linkFieldEditingController),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          addImageLink(linkFieldEditingController.text);
        },
      )
    ]);
  }
}
