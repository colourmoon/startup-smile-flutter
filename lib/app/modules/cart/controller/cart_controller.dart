import 'dart:math';

import 'package:get/get.dart';
import 'package:ebazaar/app/modules/auth/controller/auth_controler.dart';
import 'package:ebazaar/app/modules/cart/model/product_model.dart';
import 'package:ebazaar/app/modules/shipping/controller/show_address_controller.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widgets/custom_snackbar.dart';
import '../model/cart_model.dart';

class CartController extends GetxController {
  final showAddressController = Get.put(ShowAddressController());
  final AuthController splash = Get.put(AuthController());

  final authController = Get.put(AuthController());
  final cartItems = <CartModel>[].obs;
  final numOfItems = 1.obs;
  final quantityTax = 0.0.obs;
  final taxRate = 0.0.obs;
  double productShippingCharge = 0.0;
  String shippingMethod = "0";
  final shippingAreaCost = 0.0.obs;
  double totalIndividualProductTax = 0.0;
  double flatRateShippingCost = 0.0;
  double multiplyShippingAmount = 0.0;
  double deliveryCharge = 0.0;
  double kilometer = 0;
  double maxFreeDistance = 0; // in kilometers
  double total = 0;
  double totalCartValue = 0;
  int orderTypeIndex = 0;
  @override
  onInit() {
    authController.getSetting();
    super.onInit();
  }

  decrement() {
    if (numOfItems.value > 1) {
      numOfItems.value--;
    }
  }

  void addItem({
    required ProductModel product,
    int? variationId,
    String? shippingAmount,
    String? finalVariation,
    String? sku,
    dynamic taxJson,
    dynamic stock,
    dynamic shipping,
    double? totalTax,
    double? totalPrice,
    dynamic productVariationPrice,
    dynamic productVariationOldPrice,
    dynamic productVariationCurrencyPrice,
    dynamic productVariationOldCurrencyPrice,
    int? variationStock,
    String? flatShippingCost,
  }) {
    for (var item in cartItems) {
      if (item.product.data?.id == product.data?.id &&
          item.variationId == variationId) {
        item.quantity.value += numOfItems.value;
        return;
      }
    }

    cartItems.add(
      CartModel(
        product: product,
        variationId: variationId ?? 0,
        quantity: numOfItems.value,
        shippingCharge: shippingAmount ?? "0",
        finalVariationString: finalVariation ?? "null",
        sku: sku ?? "null",
        taxObject: taxJson,
        stock: stock,
        variationPrice: productVariationPrice,
        variationOldPrice: productVariationOldPrice,
        variationCurrencyPrice: productVariationCurrencyPrice,
        variationOldCurrencyPrice: productVariationOldCurrencyPrice,
        shippingObject: shipping,
        totalProductTax: totalTax,
        flatShippingCharge: flatShippingCost,
        variationStock: variationStock,
      ),
    );
  }

  void incrementItem(CartModel cartItem) {
    if (cartItem.variationStock != -1) {
      if (cartItem.variationStock! < 0) {
      } else {
        if (cartItem.quantity.value < cartItem.variationStock!) {
          // maximum purchase quantity null
          if (cartItem.product.data!.maximumPurchaseQuantity == null) {
            cartItem.quantity.value++;
          } else {
            if (cartItem.quantity.value <
                cartItem.product.data!.maximumPurchaseQuantity!) {
              cartItem.quantity.value++;
            } else {
              customSnackbar(
                "INFO".tr,
                "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
                AppColor.redColor,
              );
            }
          }
        } else {}
      }
    } else {
      if (cartItem.product.data!.stock! > 0) {
        if (cartItem.quantity < cartItem.product.data!.stock!) {
          // maximum purchase qunatity null
          if (cartItem.product.data!.maximumPurchaseQuantity == null) {
            cartItem.quantity.value++;
            update();
          } else {
            if (cartItem.quantity <
                cartItem.product.data!.maximumPurchaseQuantity!) {
              cartItem.quantity.value++;
              update();
            } else {
              customSnackbar(
                "INFO".tr,
                "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
                AppColor.redColor,
              );
            }
          }
        }
      }
    }
  }

  void decrementItem(CartModel cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity.value--;
    }
  }

  int getQuantityForProduct(ProductModel product) {
    int quantity = 0;

    for (CartModel cartItem in cartItems) {
      if (cartItem.product.data?.id == product.data?.id) {
        quantity = cartItem.quantity.value;
        break;
      }
    }
    return quantity;
  }

  void removeFromCart(CartModel cartModel) {
    if (cartModel.product.data?.fileAttachment == 5) {
      showAddressController.imageList.clear();
    }
    cartItems.remove(cartModel);
    quantityTax.value = 0.0;
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity.value);
  }

  double get totalPrice {
    final totalPrice = 0.0.obs;
    for (var item in cartItems) {
      totalPrice.value +=
          (item.quantity * double.parse(item.variationPrice.toString()));
    }
    return totalPrice.value;
  }

  double get totalTax {
    double tTax = 0.0;
    for (var item in cartItems) {
      tTax +=
          ((item.quantity * double.parse(item.variationPrice.toString())) /
              100) *
          item.totalProductTax!.toDouble();
    }
    return tTax;
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double radiationLat1 = pi * lat1 / 180;
    double radiationLat2 = pi * lat2 / 180;
    double theta = lng1 - lng2;
    double radiationTheta = pi * theta / 180;

    double distance =
        sin(radiationLat1) * sin(radiationLat2) +
        cos(radiationLat1) * cos(radiationLat2) * cos(radiationTheta);

    distance = acos(distance);
    distance = distance * 180 / pi;
    distance = distance * 60 * 1.1515;
    kilometer = distance * 1.609344;

    return kilometer;
  }

  distanceWiseDeliveryCharge({required double chargePerKilo}) {
    deliveryCharge = 0.0;

    deliveryCharge = kilometer * chargePerKilo;

    if (Get.find<ShowAddressController>().addressList.value.data == null) {
      deliveryCharge = 0;
    }
    if (orderTypeIndex == 0) {
      total = deliveryCharge + totalCartValue;
    } else if (orderTypeIndex == 1) {
      total = totalCartValue;
      deliveryCharge = 0.0;
    } else if (orderTypeIndex == 10) {
      total = totalCartValue;
      deliveryCharge = 0.0;
    }
  }
}
