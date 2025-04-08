class CartItem {
  final String productId;
  final String title;
  final String size;
  int quantity;
  final double price;
  final String image;

  CartItem({
    required this.productId,
    required this.title,
    required this.size,
    required this.quantity,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'size': size,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      title: map['title'],
      size: map['size'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
      image: map['image'],
    );
  }

  double get total => price * quantity;
}

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  factory Cart.empty() => Cart(items: []);

  double get total => items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      items: List<CartItem>.from(
        map['items'].map((item) => CartItem.fromMap(item)),
      ),
    );
  }
} 