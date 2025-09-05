import 'package:ebazaar/app/modules/home/model/category_model.dart';
import 'package:ebazaar/data/remote_services/remote_services.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final isLoading = false.obs;
  final categoryModel = CategoryModel().obs;

  Future<void> fetchCategoryHome() async {
    isLoading(true);
    final data = await RemoteServices().fetchCategory();
    print('fetchCategory data in controller: $data');
    isLoading(false);
    data.fold((error) => error.toString(), (category) {
      categoryModel.value = category;
    });
  }

  @override
  void onInit() {
    fetchCategoryHome();
    super.onInit();
  }
}
