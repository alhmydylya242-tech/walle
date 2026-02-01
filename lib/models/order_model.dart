class OrderModel {
  final String id;
  final String paintingId;
  final String userId;
  final String title;
  final String imageUrl;
  final double price;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.paintingId,
    required this.userId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'],
      paintingId: data['painting_id'],
      userId: data['user_id'],
      title: data['title'],
      imageUrl: data['image_url'],
      price: (data['price'] as num).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}