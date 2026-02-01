class PaintingModel {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String category;

  PaintingModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory PaintingModel.fromMap(Map<String, dynamic> data) {
    return PaintingModel(
      id: data['id'],
      title: data['title'],
      price: (data['price'] as num).toDouble(),
      imageUrl: data['image_url'],
      category: data['category'],
    );
  }
}