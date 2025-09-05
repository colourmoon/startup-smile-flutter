import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/server/app_server.dart';
import 'package:ebazaar/main.dart';

import '../../../../utils/api_list.dart';
import '../model/popular_product.dart';

class AllFlashController extends GetxController {
  ScrollController scrollController = ScrollController();
  final flashSaleModel = PopularProduct().obs;
  final flashSaleList = <Datum>[].obs;
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
        flashSaleModel.value = PopularProduct.fromJson(response.data);
        flashSaleList.value += flashSaleModel.value.data!;

        final meta = data["meta"];
        final lastPage = meta["last_page"];

        if (page <= lastPage) {
          hasMoreData = true;
          page++;
        } else {
          hasMoreData = false;
        }
      }
    } catch (e) {
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void loadMoreData() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchFlashSale();
      }
    });
  }

  void resetState() {
    flashSaleList.clear();
    page = 1;
    hasMoreData = false;
  }

  @override
  void onInit() {
    fetchFlashSale();
    super.onInit();
  }
}
