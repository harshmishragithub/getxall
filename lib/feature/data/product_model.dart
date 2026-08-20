class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

class ProductResponse {
  final List<ProductModel> products;
  final int total;

  ProductResponse({
    required this.products,
    required this.total,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    List rawList = json['products'] ?? [];
    List<ProductModel> productList =
        rawList.map((item) => ProductModel.fromJson(item)).toList();

    return ProductResponse(
      products: productList,
      total: json['total'] ?? 0,
    );
  }
}
