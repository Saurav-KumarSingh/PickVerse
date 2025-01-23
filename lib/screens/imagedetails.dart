import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class ImageDetailsPage extends StatelessWidget {
  final String imageUrl;

  ImageDetailsPage({super.key, required this.imageUrl});
  final _flutterMediaDownloaderPlugin = MediaDownload();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        _flutterMediaDownloaderPlugin.downloadMedia(context, imageUrl);
      },child: const Icon(Icons.arrow_downward_sharp),),

      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}