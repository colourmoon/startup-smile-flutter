import 'package:get/get.dart';
import 'package:ebazaar/app/modules/home/model/popular_product.dart';
import 'package:ebazaar/data/server/app_server.dart';
import 'package:ebazaar/main.dart';
import 'package:ebazaar/utils/api_list.dart';

class PopularProductController extends GetxController {
  final popularModel = PopularProduct().obs;

  int paginate = 1;
  int page = 1;
  int itemPerPage = 8;
  bool hasMoreData = false;

  Future<PopularProduct> fetchPopularProducts() async {
    final response = await AppServer().getRequest(
        endPoint: ApiList.mostPopular(
            paginate.toString(), page.toString(), itemPerPage.toString()),
            headers: box.read('isLogedIn') == false
            ? AppServer.getAuthHeaders()
            : AppServer.getHttpHeadersWithToken());

    if (response.statusCode == 200) {
      final data = response.data;
      popularModel.value = PopularProduct.fromJson(data);

      return popularModel.value;
    }

    return popularModel.value;
  }

  @override
  void onInit() {
    fetchPopularProducts();
    super.onInit();
  }
}
