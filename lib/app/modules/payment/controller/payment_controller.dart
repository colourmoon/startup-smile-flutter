import 'dart:io';

import 'package:dio/dio.dart' as dioo;
import 'package:dio/dio.dart';
import 'package:ebazaar/app/modules/auth/controller/auth_controler.dart';
import 'package:ebazaar/app/modules/payment/model/paymet_method.dart';
import 'package:ebazaar/app/modules/payment/views/payment_gateway_screen.dart';
import 'package:ebazaar/config/theme/app_color.dart';
import 'package:ebazaar/data/remote_services/remote_services.dart';
import 'package:ebazaar/main.dart';
import 'package:ebazaar/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

import '../../../../data/server/app_server.dart';
import '../../../../utils/api_list.dart';
import '../../shipping/controller/show_address_controller.dart';

class PaymentControllr extends GetxController {
  final paymentModel = PaymentMethodModel().obs;
  final paymentList = <Datum>[].obs;
  final paymentMethodIndex = RxInt(-1);
  final paymentMethodId = 1.obs;

  final isLoading = false.obs;

  final authController = Get.put(AuthController());

  Future<void> fetchPaymentMethods() async {
    final result = await RemoteServices().fetchPaymentMethods();

    result.fold((error) => error, (payment) {
      if (authController.cashOnDelivery == '5') {
        paymentList.clear();
        paymentList.add(payment.data![0]);
        paymentModel.value.data = paymentList;
      }

      if (authController.cashOnDelivery == '10') {
        paymentList.clear();
        for (var i = 1; i < payment.data!.length; i++) {
          paymentList.add(payment.data![i]);
          paymentModel.value.data = paymentList;
        }
      }

      if (authController.onlinePayment == '5') {
        paymentList.clear();
        for (var i = 0; i < payment.data!.length; i++) {
          paymentList.add(payment.data![i]);
          paymentModel.value.data = paymentList;
        }
      }

      if (authController.cashOnDelivery == '10' &&
          authController.onlinePayment == '5') {
        paymentList.clear();
        for (var i = 1; i < payment.data!.length; i++) {
          paymentList.add(payment.data![i]);
          paymentModel.value.data = paymentList;
        }
      }

      if (authController.onlinePayment == '10') {
        paymentList.clear();
        paymentList.add(payment.data![0]);
        paymentList.add(payment.data![1]);
        paymentModel.value.data = paymentList;
      }

      if (authController.cashOnDelivery == '10' &&
          authController.onlinePayment == '10') {
        paymentList.clear();
        paymentList.add(payment.data![1]);
        paymentModel.value.data = paymentList;
      }
    });
  }

  Future<void> confirmOrder({
    required String slug,
    required double subTotal,
    required double shippingCharge,
    required double tax,
    required double total,
    required int shippingId,
    required int billingId,
    required int outletId,
    required int couponId,
    required int orderType,
    required int source,
    required int paymentMethod,
    required String products,
    required double discount,
    required List<File> images,
  }) async {
    var dio = dioo.Dio();
    dioo.FormData formData = dioo.FormData();

    formData.fields.addAll([
      MapEntry("subtotal", subTotal.toString()),
      MapEntry("delivery_charge", shippingCharge.toString()),
      MapEntry("tax", tax.toString()),
      MapEntry("total", total.toString()),
      MapEntry("discount", discount.toString()),
      MapEntry("address_id", shippingId.toString()),
      MapEntry(
          "delivery_zone_id",
          Get.find<ShowAddressController>()
                  .addressZoneModel
                  .value
                  .data
                  ?.id
                  .toString() ??
              "0"),
      MapEntry("billing_id", billingId.toString()),
      MapEntry("outlet_id", outletId.toString()),
      MapEntry("coupon_id", couponId.toString()),
      MapEntry("order_type", orderType.toString()),
      MapEntry("source", source.toString()),
      MapEntry("payment_method", paymentMethod.toString()),
      MapEntry("products", products),
    ]);

    for (int i = 0; i < images.length; i++) {
      File imageFile = images[i];
      formData.files.add(MapEntry(
        "images[]",
        await dioo.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.uri.pathSegments.last,
        ),
      ));
    }

    print('Sending data:');
    for (var field in formData.fields) {
      print('${field.key}: ${field.value}');
    }
    for (var file in formData.files) {
      print('${file.key}: ${file.value.filename}');
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          print('Response: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('Error: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    try {
      var response = await dio.post(
        ApiList.confirmOrder,
        data: formData,
        options: Options(
            validateStatus: (status) => status! < 500,
            headers: box.read('isLogedIn') == false
                ? AppServer.getAuthHeaders()
                : AppServer.getHttpHeadersWithToken()),
      );

      print('response: $response');
      print('response: ${response.statusCode}');
      print('response: ${response.data}');


  

      if (response.statusCode == 201) {
        Get.find<ShowAddressController>().imageList.clear();
        isLoading(false);
        int orderId = response.data['data']['id'];
        Get.to(() => PaymentView(
              orderId: orderId,
              slug: slug,
            ));
      } else {
        isLoading(false);
        Future.delayed(const Duration(milliseconds: 10), () {
          customSnackbar("ERROR".tr, response.data['message'], AppColor.error);
          update();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onInit() {
    fetchPaymentMethods();
    authController.getSetting();
    super.onInit();
  }
}
