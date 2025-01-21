import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageGridPage(),
    );
  }
}

class ImageData {
  final String previewURL;
  final String pageURL;
  final String userImageURL;
  final String userName;
  final int imageWidth;
  final int imageHeight;

  ImageData({
    required this.previewURL,
    required this.pageURL,
    required this.userImageURL,
    required this.userName,
    required this.imageWidth,
    required this.imageHeight,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      previewURL: json['previewURL'],
      pageURL: json['pageURL'],
      userImageURL: json['userImageURL'],
      userName: json['user'],
      imageWidth: json['imageWidth'],
      imageHeight: json['imageHeight'],
    );
  }
}

class ImageGridPage extends StatefulWidget {
  @override
  _ImageGridPageState createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage> {
  List<ImageData> _images = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchImages(); // Fetch images initially with an empty query or default query
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse('https://pixabay.com/api/?key=46437507-3acf8a6678b723e6b1b09f589&q=$_searchQuery'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _images = (data['hits'] as List)
            .map((item) => ImageData.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  void showFullScreenPreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: SizedBox(
                height: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'assets/logo.png', // Replace with your logo asset path
                height: 50,
              ),
            ),
            Expanded(
              child: Material(
                elevation: 1.0, // Adding elevation to give it a shadow effect
                borderRadius: BorderRadius.circular(30.0), // Rounded corners for the material
                color: Colors.white, // Background color for the text field
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search images...',
                    hintStyle: TextStyle(color: Colors.black), // Style for hint text
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted padding to reduce height
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Border radius for rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey, // Color of the border when the field is not focused
                        width: 1.0, // Width of the border
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Maintain rounded corners when focused
                      borderSide: BorderSide(
                        color: Colors.purple, // Color of the border when the field is focused
                        width: 1.0, // Slightly thicker border when focused
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Maintain rounded corners when enabled
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), // Lighter border color when enabled
                        width: 1.0, // Border width
                      ),
                    ),
                  ),
                  style: TextStyle(color: Colors.black), // Style for the text inside the text field
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSubmitted: (value) {
                    fetchImages();
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                fetchImages(); // Trigger search when button is pressed
              },
            ),
          ],
        ),
      ),
      body: _images.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Wrap(
                spacing: 8.0, // Horizontal spacing between items
                runSpacing: 8.0, // Vertical spacing between rows
                children: _images.map((image) {
                  return GestureDetector(
                    onTap: () {
                      showFullScreenPreview(context, image.previewURL);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: image.imageWidth / image.imageHeight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                image.previewURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
