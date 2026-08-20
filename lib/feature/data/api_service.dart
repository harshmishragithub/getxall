import 'package:get/get.dart';
import 'product_model.dart';

class ApiService extends GetConnect {
  Future<ProductResponse?> fetchProducts({
    String query = '',
    int skip = 0,
    int limit = 10,
  }) async {
    String url = '';

    if (query.trim().isNotEmpty) {
      url = 'https://dummyjson.com/products/search?q=$query&limit=$limit&skip=$skip';
    } else {
      url = 'https://dummyjson.com/products?limit=$limit&skip=$skip';
    }

    final response = await get(url);

    if (response.status.hasError || response.body == null) {
      return null;
    }

    return ProductResponse.fromJson(response.body);
  }
}
