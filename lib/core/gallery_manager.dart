import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:webgallery/core/app_exception.dart';

class GalleryManager{

  Future<Gallery> loadGallery() async {
    var fileResult = await FilePicker.platform.pickFiles();
    if(fileResult == null) {
      throw AppException('File not selected!');
    }
    try {
      var filePath = fileResult.files.single.path as String;
      var file = File(filePath);
      var fileContent = await file.readAsString(encoding: utf8);
      var jsonContent = jsonDecode(fileContent);
      return Gallery.fromJson(jsonContent);
    } catch(_) {
      throw AppException('Invalid file!');
    }
  }

  Future<void> saveGallery(Gallery gallery) async {
    var json = jsonEncode(gallery);
    var filename = 'gallery-${DateTime.now().microsecondsSinceEpoch.toString()}.json';
    var path = await FilePicker.platform.saveFile(dialogTitle: 'Choose the path to save the gallery', fileName: filename);
    if(path == null) {
      throw AppException('File no selected!');
    }
    var file = File(path);
    file.writeAsString(json, encoding: utf8);
  }
}

class Gallery {
  String name;
  final List<String> urls;

  Gallery(this.name, this.urls);

  Map<String, dynamic> toJson() {
    return {"name": name, "urls": urls};
  }

  static Gallery fromJson(Map<String, dynamic> json) {
    return Gallery(json['name'], (json['urls'] as List<dynamic>).cast<String>());
  }
}