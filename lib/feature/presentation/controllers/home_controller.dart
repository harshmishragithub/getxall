import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/api_service.dart';
import '../../data/product_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables
  var productList = <ProductModel>[].obs;
  var isLoading = true.obs;          // Initial page loading
  var isLoadingMore = false.obs;      // Bottom pagination loader
  var searchQuery = ''.obs;           // Search input text
  var isAscending = true.obs;         // Price Sorting order

  // Pagination variables
  int skip = 0;
  final int limit = 10;
  int totalProducts = 0;

  // Controllers
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // 1. Initial data fetch
    fetchProducts();

    // 2. GETX DEBOUNCE: Typing band hone ke 500ms baad search API call hogi
    debounce(
      searchQuery,
      (_) => fetchProducts(isRefresh: true),
      time: const Duration(milliseconds: 500),
    );

    // 3. PAGINATION SCROLL LISTENER: Bottom tak pahuche par next page load hoga
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading.value &&
          !isLoadingMore.value &&
          productList.length < totalProducts) {
        loadMoreProducts();
      }
    });
  }

  // Initial fetch ya search refresh ke liye
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      skip = 0;
    }

    isLoading.value = true;

    var response = await _apiService.fetchProducts(
      query: searchQuery.value,
      skip: 0,
      limit: limit,
    );

    if (response != null) {
      productList.assignAll(response.products);
      totalProducts = response.total;
      skip = response.products.length;

      _applySort();
    }

    isLoading.value = false;
  }

  // Load More items (Next Page)
  Future<void> loadMoreProducts() async {
    isLoadingMore.value = true;

    var response = await _apiService.fetchProducts(
      query: searchQuery.value,
      skip: skip,
      limit: limit,
    );

    if (response != null && response.products.isNotEmpty) {
      productList.addAll(response.products);
      skip += response.products.length;

      _applySort();
    }

    isLoadingMore.value = false;
  }

  // Price Sorting Function (Low <-> High toggle)
  void togglePriceSort() {
    isAscending.value = !isAscending.value;
    _applySort();
  }

  // Helper method for sorting list by price
  void _applySort() {
    if (isAscending.value) {
      productList.sort((a, b) => a.price.compareTo(b.price));
    } else {
      productList.sort((a, b) => b.price.compareTo(a.price));
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
