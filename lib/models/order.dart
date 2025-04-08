class OrderItem {
  final String productId;
  final String title;
  final String size;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.title,
    required this.size,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'size': size,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      title: map['title'],
      size: map['size'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final String shippingAddress;
  final DateTime createdAt;
  final String? invoiceUrl;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
    this.invoiceUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt.toIso8601String(),
      'invoiceUrl': invoiceUrl,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['userId'],
      items: List<OrderItem>.from(
        map['items'].map((item) => OrderItem.fromMap(item)),
      ),
      total: map['total'].toDouble(),
      status: map['status'],
      shippingAddress: map['shippingAddress'],
      createdAt: DateTime.parse(map['createdAt']),
      invoiceUrl: map['invoiceUrl'],
    );
  }
} 