import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class GalleryManager{

  Future<Gallery> loadGallery() async {
    var fileResult = await FilePicker.platform.pickFiles();
    if(fileResult == null) {
      throw Exception('File not selected!');
    }
    var filePath = fileResult.files.single.path as String;
    var file = File(filePath);
    var fileContent = await file.readAsString(encoding: utf8);
    var jsonContent = jsonDecode(fileContent);
    return Gallery.fromJson(jsonContent);
  }

  void saveGallery(Gallery gallery) async {
    var json = jsonEncode(gallery);
    var path = await FilePicker.platform.getDirectoryPath();
    var filename = 'gallery-${DateTime.now().microsecondsSinceEpoch.toString()}.json';
    var file = File("$path/$filename");
    file.writeAsString(json, encoding: utf8);
  }
}

class Gallery {
  final String name;
  final List<String> urls;

  Gallery(this.name, this.urls);

  Map<String, dynamic> toJson() {
    return {"name": name, "urls": urls};
  }

  static Gallery fromJson(Map<String, dynamic> json) {
    return Gallery(json['name'], (json['urls'] as List<dynamic>).cast<String>());
  }
}