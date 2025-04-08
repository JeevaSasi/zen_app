import '../models/product.dart';
import '../models/order.dart';
import '../models/cart.dart';

class MockData {
  static final List<Product> products = [
    Product(
      id: '1',
      title: 'Premium Karate Gi',
      description: 'Professional grade karate uniform made from high-quality cotton. Perfect for training and competitions.',
      price: 89.99,
      category: 'Uniforms',
      images: [
        'https://cdn.budoland.com/media/catalog/product/cache/d075c5857850b48130bcddc5dd77bf85/h/a/hayashi-gi-0475-1-white-white-c-0475-left.jpg',
      ],
      sizes: ['S', 'M', 'L', 'XL'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '2',
      title: 'Black Belt - Premium',
      description: 'High-quality black belt made from durable cotton. Perfect for advanced practitioners.',
      price: 29.99,
      category: 'Belts',
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAWRLRmpxvPrlgpVrrQY-Y6REXZBgBXv8rCA&s',
      ],
      sizes: ['280cm', '300cm', '320cm'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '3',
      title: 'Training Gloves',
      description: 'Protective training gloves with excellent grip and padding.',
      price: 34.99,
      category: 'Protection',
      images: [
        'https://dragonsports.in/wp-content/uploads/2021/09/smai-glov-1.jpg',
      ],
      sizes: ['S', 'M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '4',
      title: 'Sparring Head Guard',
      description: 'Professional head protection with excellent visibility and comfort.',
      price: 45.99,
      category: 'Protection',
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFpgZhLghkYNKdQnlmxeZzUugI-e0ZDnIV9A&s',
      ],
      sizes: ['S', 'M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '5',
      title: 'Kids Karate Uniform',
      description: 'Lightweight and durable karate uniform perfect for young practitioners.',
      price: 49.99,
      category: 'Uniforms',
      images: [
        'https://images-cdn.ubuy.co.in/654a17a2ef4bf17ae44f960d-namazu-karate-uniform-for-kids-and.jpg',
      ],
      sizes: ['4-6Y', '6-8Y', '8-10Y', '10-12Y'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '6',
      title: 'Training Focus Pads',
      description: 'High-quality focus mitts for precision training and improved accuracy.',
      price: 39.99,
      category: 'Accessories',
      images: [
        'https://m.media-amazon.com/images/I/71tbHG9Y1FL._AC_UF894,1000_QL80_.jpg',
      ],
      sizes: ['One Size'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '7',
      title: 'Foam Training Nunchucks',
      description: 'Safe foam nunchucks for practice and demonstrations.',
      price: 24.99,
      category: 'Accessories',
      images: [
        'https://images.meesho.com/images/products/359361757/qvzbk_512.webp',
      ],
      sizes: ['One Size'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '8',
      title: 'Competition Belt - Various Colors',
      description: 'Official competition belts available in all ranks.',
      price: 19.99,
      category: 'Belts',
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAWRLRmpxvPrlgpVrrQY-Y6REXZBgBXv8rCA&s',
      ],
      sizes: ['280cm', '300cm'],
      createdAt: DateTime.now(),
    ),
  ];

  static final List<Order> orders = [
    Order(
      id: '1001',
      userId: 'user123',
      items: [
        OrderItem(
          productId: '1',
          title: 'Premium Karate Gi',
          size: 'L',
          quantity: 1,
          price: 89.99,
        ),
        OrderItem(
          productId: '2',
          title: 'Black Belt - Premium',
          size: '300cm',
          quantity: 1,
          price: 29.99,
        ),
      ],
      total: 119.98,
      status: 'Processing',
      shippingAddress: '123 Main St, Apt 4B\nNew York, NY 10001',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Order(
      id: '1002',
      userId: 'user123',
      items: [
        OrderItem(
          productId: '3',
          title: 'Training Gloves',
          size: 'M',
          quantity: 2,
          price: 34.99,
        ),
      ],
      total: 69.98,
      status: 'Delivered',
      shippingAddress: '123 Main St, Apt 4B\nNew York, NY 10001',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      invoiceUrl: 'https://example.com/invoices/1002.pdf',
    ),
  ];

  static Cart cart = Cart(items: [
    CartItem(
      productId: '1',
      title: 'Premium Karate Gi',
      size: 'L',
      quantity: 1,
      price: 89.99,
      image: 'https://cdn.budoland.com/media/catalog/product/cache/d075c5857850b48130bcddc5dd77bf85/h/a/hayashi-gi-0475-1-white-white-c-0475-left.jpg'
    ),
  ]);
} 