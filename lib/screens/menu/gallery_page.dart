import 'package:flutter/material.dart';
import '../../widgets/shimmer_widget.dart';
import '../../services/api_service.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _isLoading = true;
  final List<String> _galleryImages = [];
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      setState(() => _isLoading = true);
      final images = await _apiService.getGalleryImages();
      
      if (mounted) {
        setState(() {
          _galleryImages.clear();
          _galleryImages.addAll(images);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Show error state if needed
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadImages,
          ),
        ],
      ),
      body: _isLoading ? _buildShimmer() : _buildGallery(),
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ShimmerWidget.rectangular(
        height: double.infinity,
      ),
    );
  }

  Widget _buildGallery() {
    if (_galleryImages.isEmpty) {
      return const Center(
        child: Text('No images available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadImages,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: _galleryImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _FullScreenImage(
                    imageUrl: _galleryImages[index],
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _galleryImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                    ),
                  );
                },
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
