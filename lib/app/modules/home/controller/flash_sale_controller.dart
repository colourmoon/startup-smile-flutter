import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/app/modules/home/model/popular_product.dart';
import 'package:ebazaar/main.dart';
import 'package:ebazaar/utils/api_list.dart';
import '../../../../data/server/app_server.dart';

class FlashSaleControlelr extends GetxController {
  ScrollController scrollController = ScrollController();
  final flashSaleModel = PopularProduct().obs;
  int paginate = 1;
  int page = 1;
  int itemPerPage = 8;
  final isLoading = false.obs;
  final lastPage = 1.obs;
  bool hasMoreData = false;
  Dio dio = Dio();

  Future<void> fetchFlashSale() async {
    isLoading(true);
    try {
      final response = await AppServer().getRequest(
          endPoint:
              "${ApiList.baseUrl}/api/frontend/product/flash-sale-products?paginate=${paginate.toString()}&page=${page.toString()}&per_page=${itemPerPage.toString()}",
          headers: box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken());
      isLoading(false);
      if (response.statusCode == 200) {
        final data = response.data;
        flashSaleModel.value = PopularProduct.fromJson(data);
      }
    } catch (e) {
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    fetchFlashSale();
    super.onInit();
  }
}
