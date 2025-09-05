import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ebazaar/app/modules/wishlist/model/fav_model.dart';
import 'package:ebazaar/utils/api_list.dart';
import '../../../../data/server/app_server.dart';
import '../../../../main.dart';

class WishlistController extends GetxController {
  final favList = <int>{}.obs;
  final favoriteModel = FavoriteModel().obs;
  final isLoading = false.obs;

  fetchFavorite() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(ApiList.showWishlist),
          headers: box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken());

      if (response.statusCode == 200) {
        isLoading(false);
        final jsonString = response.body;
        final data = favoriteModelFromJson(jsonString);
        favoriteModel.value = data;
        favoriteModel.value.data?.map((e) => favList.add(e.id!)).toList();
      }
    } catch (e) {
      isLoading(false);
    }
  }

  toggleFavoriteFalse(int productId) async {
    var dio = Dio();
    try {
      var response = await dio.post(ApiList.wishList,
          options: Options(
            headers: box.read('isLogedIn') == false
                ? AppServer.getAuthHeaders()
                : AppServer.getHttpHeadersWithToken(),
          ),
          data: {
            "product_id": productId.toString(),
            "toggle": '0',
          });

      if (response.statusCode == 202) {
        refresh();
        update();
      }
    } catch (e) {}
  }

  toggleFavoriteTrue(int productId) async {
    var dio = Dio();
    try {
      var response = await dio.post(ApiList.wishList,
          options: Options(
              headers: box.read('isLogedIn') == false
                  ? AppServer.getAuthHeaders()
                  : AppServer.getHttpHeadersWithToken()),
          data: {
            "product_id": productId.toString(),
            "toggle": '1',
          });

      if (response.statusCode == 202) {
        refresh();
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  showFavorite(int id) {
    if (favList.contains(id)) {
      toggleFavoriteFalse(id);
      favList.remove(id);
    } else {
      favList.add(id);
    }
  }

  @override
  void onInit() {
    fetchFavorite();
    super.onInit();
  }
}
