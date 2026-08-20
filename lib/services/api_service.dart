import 'package:get/get.dart';
import '../models/product_model.dart';

class ApiService extends GetConnect {
  // Fetch products with search, pagination limit & skip
  Future<ProductResponse?> fetchProducts({
    String query = '',
    int skip = 0,
    int limit = 10,
  }) async {
    String url = '';

    if (query.trim().isNotEmpty) {
      // 1. Agar search bar me text hai to search URL
      url = 'https://dummyjson.com/products/search?q=$query&limit=$limit&skip=$skip';
    } else {
      // 2. Agar search bar khali hai to normal list URL
      url = 'https://dummyjson.com/products?limit=$limit&skip=$skip';
    }

    final response = await get(url);

    if (response.status.hasError || response.body == null) {
      return null;
    }

    return ProductResponse.fromJson(response.body);
  }
}
