class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final List<String> sizes;
  final bool isAvailable;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.sizes,
    this.isAvailable = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'sizes': sizes,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'].toDouble(),
      category: map['category'],
      images: List<String>.from(map['images']),
      sizes: List<String>.from(map['sizes']),
      isAvailable: map['isAvailable'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
} 