import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pickverse/screens/imagedetails.dart';
import 'package:pickverse/screens/profile.dart';

class GooglePhotosUI extends StatefulWidget {
  const GooglePhotosUI({super.key});

  @override
  _GooglePhotosUIState createState() => _GooglePhotosUIState();
}

class _GooglePhotosUIState extends State<GooglePhotosUI> {
  List<String> images = []; // List to store fetched image URLs
  List<bool> likedStatus = []; // List to track liked status
  List<String> likedImages = []; // Store URLs of liked images
  String searchQuery = ""; // To store search input
  int _currentIndex = 0;

  // Fetch images from Pexels API
  Future<void> fetchImages(String query) async {
    const String apiKey = 'MAQqyNhwxkb3znWasX5WXMVaSxB9HmqfQx8xlhN8oM4ZobxL6OxEeAd7'; // Replace with your Pexels API key
    final String url = 'https://api.pexels.com/v1/search?query=$query&per_page=20';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List photos = data['photos'];

        setState(() {
          images = photos.map((photo) => photo['src']['medium'] as String).toList();
          likedStatus = List.filled(images.length, false);
        });
      } else {
        print('Failed to fetch images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImages("nature"); // Fetch nature images when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 45,
              width: 45,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: TextField(
                onChanged: (value) => searchQuery = value,
                onSubmitted: (value) {
                  fetchImages(value); // Fetch images when user submits query
                },
                decoration: const InputDecoration(
                  hintText: 'Search for images...',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                fetchImages(searchQuery); // Fetch images on search button click
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: images.isEmpty
            ? const Center(
          child: Text(
            'Search for images to display here.',
            style: TextStyle(fontSize: 16),
          ),
        )
            : MasonryGridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to ImageDetailsPage
                Navigator.push(

                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageDetailsPage(
                      imageUrl: images[index],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Add spacing between images
                child: Stack(
                  children: [
                    // Image Container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    // Like Button Positioned at Top-Right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            likedStatus[index] = !likedStatus[index];
                            if (likedStatus[index]) {
                              likedImages.add(images[index]);
                            } else {
                              likedImages.remove(images[index]);
                            }
                          });
                        },
                        child: Icon(
                          likedStatus[index] ? Icons.favorite : Icons.favorite_border,
                          color: likedStatus[index] ? Colors.red : Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex, // To track the selected tab
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
          });
          if (index == 1) {
            // Navigate to LikesPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LikesPage(likedImages: likedImages),
              ),
            );
          }
          if (index == 2) {
            // Navigate to ProfilePage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class LikesPage extends StatelessWidget {
  final List<String> likedImages;

  const LikesPage({super.key, required this.likedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Images'),
      ),
      body: likedImages.isEmpty
          ? const Center(child: Text('No liked images yet.'))
          : GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: likedImages.length,
        itemBuilder: (context, index) {
          return Container(
            child: Image.network(
              likedImages[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}


