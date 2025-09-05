import 'dart:io';

import 'package:ebazaar/app/modules/shipping/model/address_zone_model.dart';
import 'package:ebazaar/config/theme/app_color.dart';
import 'package:ebazaar/data/server/app_server.dart';
import 'package:ebazaar/utils/api_list.dart';
import 'package:ebazaar/widgets/custom_snackbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ebazaar/app/modules/shipping/model/outlet_model.dart';
import 'package:ebazaar/app/modules/shipping/model/show_address.dart';
import 'package:ebazaar/data/remote_services/remote_services.dart';
import 'package:ebazaar/main.dart';
import 'package:image_picker/image_picker.dart';
import '../model/area_shipping.dart';

class ShowAddressController extends GetxController {
  final addressSelected = false.obs;
  final billingAddressSelected = true.obs;
  final isLoading = false.obs;
  final addressList = ShowAddressModel().obs;
  final outlestModel = OutletModel().obs;
  final areaShippingModel = AreaShippingModel().obs;
  final addressZoneModel = AddressZoneModel().obs;

  final selectedAddressIndex = RxInt(-1);
  final selectedBillingAddressIndex = RxInt(-1);

  final selectedOutletIndex = RxInt(-1);

  final selectedPickUp = false.obs;
  final zoneStatus = false.obs;

  final imageList = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> showAdresses() async {
    isLoading(true);
    final result = await RemoteServices().fetchAddress();
    isLoading(false);

    result.fold(
      (error) {
        isLoading(false);
      },
      (address) {
        isLoading(false);
        addressList.value = address;

        return addressList.value;
      },
    );
  }

  Future<void> fetchOutlets() async {
    final result = await RemoteServices().fetchOutlets();

    result.fold((error) => error, (outlet) {
      outlestModel.value = outlet;
    });
  }

  void setSelectedAddressIndex(int index) {
    selectedAddressIndex.value = index;
  }

  void setSelectedBillingAddressIndex(int index) {
    selectedBillingAddressIndex.value = index;
  }

  void setoutletIndex(int index) {
    selectedOutletIndex.value = index;
  }

  Future<void> checkDeliveryZone(
      {required String addressId,
      required String userId,
      required String label,
      required String address,
      required String latitude,
      required String longitude}) async {
    try {
      final response = await AppServer().getRequest(
          endPoint: ApiList.checkDeliveryZone(
              addressId: addressId,
              userId: userId,
              label: label,
              address: address,
              latitude: latitude,
              longitude: longitude),
          headers: AppServer.getHttpHeadersWithToken());

      if (response.statusCode == 200) {
        zoneStatus.value = true;
        addressZoneModel.value = AddressZoneModel.fromJson(response.data);
      } else {
        zoneStatus.value = false;
        customSnackbar(
            "ERROR", response.data['data']['message'], AppColor.redColor);
      }
    } catch (e) {
      zoneStatus.value = false;
      customSnackbar("ERROR", "YOUR_ADDRESS_IS_OUT_OF_OUR_SERVICE_AREA".tr,
          AppColor.redColor);
    }
  }

  Future<void> pickImages() async {
    if (imageList.length >= 5) {
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      String extension = imageFile.path.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        Fluttertoast.showToast(msg: "PLEASE_SELECT_JPEG_JPG_OR_PNG".tr);
        return;
      }

      int imageSize = await imageFile.length();
      if (imageSize > 2 * 1024 * 1024) {
        Fluttertoast.showToast(msg: "IMAGE_SIZE_SHOULD_NOT_EXCEED_2MB".tr);
        return;
      }

      imageList.add(imageFile);
    } else {
      Fluttertoast.showToast(msg: "No image selected.");
    }
  }

  deleteImageFromList(int index) {
    imageList.removeAt(index);
  }

  @override
  void onInit() {
    if (box.read('isLogedIn') != false) {
      showAdresses();
      fetchOutlets();
    }
    super.onInit();
  }
}
