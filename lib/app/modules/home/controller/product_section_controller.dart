import 'package:ebazaar/app/modules/home/model/product_section.dart';
import 'package:ebazaar/data/remote_services/remote_services.dart';
import 'package:get/get.dart';

class ProductSectionController extends GetxController {
  final isLoading = false.obs;
  final productSection = ProductSectionModel().obs;

  Future<void> fetchProductSectionHome() async {
    isLoading(true);
    final data = await RemoteServices().fetchProductSection();
    isLoading(false);
    data.fold((error) => error.toString(), (sectionModel) {
      productSection.value = sectionModel;
    });
  }

  @override
  void onInit() {
    fetchProductSectionHome();
    super.onInit();
  }
}
