import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> galleryImages = [
      'https://karate.news/wp-content/uploads/2023/05/image-36.jpeg',
      'https://www.shutterstock.com/image-illustration/karate-martial-arts-sports-silhouette-260nw-2128287515.jpg',
      'https://www.shutterstock.com/shutterstock/photos/2116869461/display_1500/stock-vector-karate-logo-silhouette-with-brush-vector-2116869461.jpg',
      'https://www.shutterstock.com/image-illustration/karate-martial-arts-sports-silhouette-260nw-2128287515.jpg',
      'https://karate.news/wp-content/uploads/2023/05/image-36.jpeg',
      'https://www.shutterstock.com/shutterstock/photos/658599034/display_1500/stock-photo-a-young-martial-arts-master-knots-a-black-belt-close-up-image-with-the-effect-of-sunlight-658599034.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHgWS4Cgbdo2uqVlSRgiS1vtgaZT-gAbNhhA&s',
       'https://www.shutterstock.com/image-illustration/karate-martial-arts-sports-silhouette-260nw-2128287515.jpg',
      'https://karate.news/wp-content/uploads/2023/05/image-36.jpeg'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: galleryImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Open image in fullscreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _FullScreenImage(
                    imageUrl: galleryImages[index],
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                galleryImages[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
