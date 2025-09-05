import 'package:dotted_border/dotted_border.dart';
import 'package:ebazaar/app/modules/address/controller/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ebazaar/app/modules/auth/controller/auth_controler.dart';
import 'package:ebazaar/app/modules/cart/controller/cart_controller.dart';
import 'package:ebazaar/app/modules/coupon/views/apply_coupon_screen.dart';
import 'package:ebazaar/app/modules/coupon/controller/coupon_controller.dart';
import 'package:ebazaar/app/modules/payment/controller/payment_controller.dart';
import 'package:ebazaar/app/modules/shipping/controller/show_address_controller.dart';
import 'package:ebazaar/app/modules/shipping/widgets/address_widget.dart';
import 'package:ebazaar/main.dart';
import 'package:ebazaar/widgets/appbar3.dart';
import 'package:ebazaar/widgets/custom_snackbar.dart';
import 'package:ebazaar/widgets/devider.dart';
import 'package:ebazaar/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/location_permission_dialouge.dart';
import '../../address/views/add_pick_location_view.dart';
import '../../address/widget/editAddress/edit_pick_location_view.dart';
import '../../payment/views/payment_screen.dart';
import '../widgets/add_button.dart';
import '../widgets/edit_button.dart';
import '../widgets/order_summary.dart';

class ShippingInformationScreen extends StatefulWidget {
  const ShippingInformationScreen({super.key});

  @override
  State<ShippingInformationScreen> createState() =>
      _ShippingInformationScreenState();
}

class _ShippingInformationScreenState extends State<ShippingInformationScreen> {
  bool isDelivery = true;
  final showAddressController = Get.put(ShowAddressController());
  final addressController = Get.put(AddressController());
  final couponController = Get.put(CouponController());
  final cartController = Get.find<CartController>();
  final paymentController = Get.put(PaymentControllr());
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    showAddressController.showAdresses();
    showAddressController.fetchOutlets();
    paymentController.fetchPaymentMethods();
    showAddressController.selectedAddressIndex.value = -1;
    showAddressController.selectedBillingAddressIndex.value = -1;
    cartController.deliveryCharge = 0.0;
    isFileAttached();
  }

  openCoupon() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder:
          (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const ApplyCouponScreen(),
          ),
    );
  }

  Widget buildImageGrid() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: showAddressController.imageList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
        ),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Image.file(showAddressController.imageList[index]),
                    );
                  },
                  child: Image.file(
                    showAddressController.imageList[index],
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -1,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    showAddressController.deleteImageFromList(index);
                  },
                  child: Container(
                    height: 16.h,
                    width: 16.w,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: SvgPicture.asset(SvgIcon.close, height: 16.h),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    cartController.productShippingCharge = 0;
    cartController.shippingAreaCost.value = 0;
    super.dispose();
  }

  bool isFileAttached() {
    for (var cart in cartController.cartItems) {
      if (cart.product.data?.fileAttachment == 5) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColor.primaryBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: AppBarWidget3(text: 'Shipping Information'.tr),
        ),
        body: RefreshIndicator(
          color: AppColor.primaryColor,
          onRefresh: () async {
            if (box.read('isLogedIn') != false) {
              showAddressController.fetchOutlets();
              showAddressController.showAdresses();
              paymentController.fetchPaymentMethods();
              showAddressController.selectedAddressIndex.value = -1;
              cartController.deliveryCharge = 0.0;
              setState(() {});
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32.h,
                    width: 161.w,
                    decoration: BoxDecoration(
                      color: AppColor.selectDeliveyColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDelivery = true;
                                showAddressController
                                    .selectedOutletIndex
                                    .value = -1;
                              });
                            },
                            child: Container(
                              height: 32.h,
                              width: 83.w,
                              decoration: BoxDecoration(
                                color:
                                    isDelivery
                                        ? AppColor.deliveryColor
                                        : AppColor.selectDeliveyColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: 'Delivery'.tr,
                                  color:
                                      isDelivery
                                          ? AppColor.whiteColor
                                          : AppColor.deliveryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDelivery = false;
                                showAddressController
                                    .selectedAddressIndex
                                    .value = -1;
                                showAddressController
                                    .selectedBillingAddressIndex
                                    .value = -1;
                              });
                            },
                            child: Container(
                              height: 32.h,
                              width: 78.w,
                              decoration: BoxDecoration(
                                color:
                                    isDelivery
                                        ? AppColor.selectDeliveyColor
                                        : AppColor.deliveryColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: 'Pick Up'.tr,
                                  color:
                                      isDelivery
                                          ? AppColor.deliveryColor
                                          : AppColor.whiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  isDelivery == false
                      ? Obx(
                        () =>
                            showAddressController.outlestModel.value.data ==
                                    null
                                ? const SizedBox()
                                : GestureDetector(
                                  onTap: () {
                                    showAddressController.selectedPickUp.value =
                                        !showAddressController
                                            .selectedPickUp
                                            .value;
                                  },
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        showAddressController
                                            .outlestModel
                                            .value
                                            .data!
                                            .length,
                                    itemBuilder: (context, index) {
                                      final outlet =
                                          showAddressController
                                              .outlestModel
                                              .value
                                              .data![index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.h,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            showAddressController
                                                .setoutletIndex(index);
                                          },
                                          child: Obx(
                                            () => Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    showAddressController
                                                                .selectedOutletIndex
                                                                .value ==
                                                            index
                                                        ? AppColor.primaryColor1
                                                        : AppColor.addressColor,
                                                border: Border.all(
                                                  color:
                                                      showAddressController
                                                                  .selectedOutletIndex
                                                                  .value ==
                                                              index
                                                          ? AppColor
                                                              .primaryColor
                                                          : Colors.transparent,
                                                  width: 1.r,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.r),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                      showAddressController
                                                                  .selectedOutletIndex
                                                                  .value ==
                                                              index
                                                          ? SvgIcon.radioActive
                                                          : SvgIcon.radio,
                                                      color:
                                                          showAddressController
                                                                      .selectedOutletIndex
                                                                      .value ==
                                                                  index
                                                              ? AppColor
                                                                  .primaryColor
                                                              : null,
                                                      height: 16.h,
                                                      width: 16.w,
                                                    ),
                                                    SizedBox(width: 16.w),
                                                    AddressCard(
                                                      label: outlet.name ?? "",
                                                      streetAddress:
                                                          outlet.address ?? "",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: 'DELIVERY_ADDRESS'.tr,
                            color: AppColor.textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          Row(
                            children: [
                              Obx(
                                () =>
                                    showAddressController
                                                .selectedAddressIndex
                                                .value !=
                                            -1
                                        ? EditButton(
                                          text: "Edit".tr,
                                          onTap: () {
                                            Get.to(
                                              () => EditPickLocationView(
                                                addressData:
                                                    addressController
                                                        .addressDataList[addressController
                                                        .selectedAddress!],
                                              ),
                                            );
                                          },
                                        )
                                        : const SizedBox(),
                              ),
                              SizedBox(width: 12.w),
                              AddButton(
                                text: "Add".tr,
                                onTap:
                                    () => _checkPermission(() async {
                                      Get.to(AddPickLocationView());
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                  SizedBox(height: 12.h),
                  box.read('isLogedIn') == false
                      ? const Center(child: SizedBox())
                      : isDelivery == false
                      ? const SizedBox()
                      : Obx(
                        () =>
                            showAddressController.addressList.value.data == null
                                ? const SizedBox()
                                : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      showAddressController
                                          .addressList
                                          .value
                                          .data
                                          ?.length,
                                  itemBuilder: (context, index) {
                                    final address =
                                        showAddressController
                                            .addressList
                                            .value
                                            .data;
                                    return GestureDetector(
                                      onTap: () async {
                                        addressController.selectedAddress =
                                            index;
                                        await showAddressController
                                            .checkDeliveryZone(
                                              addressId:
                                                  address![index].id.toString(),
                                              userId:
                                                  address[index].userId
                                                      .toString(),
                                              label:
                                                  address[index].label
                                                      .toString(),
                                              address:
                                                  address[index].address
                                                      .toString(),
                                              latitude:
                                                  address[index].latitude
                                                      .toString(),
                                              longitude:
                                                  address[index].longitude
                                                      .toString(),
                                            );

                                        setState(() {
                                          if (showAddressController
                                              .zoneStatus
                                              .value) {
                                            showAddressController
                                                .setSelectedAddressIndex(index);
                                            if (showAddressController
                                                    .selectedAddressIndex
                                                    .value !=
                                                -1) {
                                              double addressLat = double.parse(
                                                showAddressController
                                                    .addressList
                                                    .value
                                                    .data![showAddressController
                                                        .selectedAddressIndex
                                                        .value]
                                                    .latitude
                                                    .toString(),
                                              );

                                              double addressLong = double.parse(
                                                showAddressController
                                                    .addressList
                                                    .value
                                                    .data![showAddressController
                                                        .selectedAddressIndex
                                                        .value]
                                                    .longitude
                                                    .toString(),
                                              );

                                              final branchLat = double.parse(
                                                showAddressController
                                                        .addressZoneModel
                                                        .value
                                                        .data
                                                        ?.latitude
                                                        .toString() ??
                                                    '',
                                              );
                                              final branchLong = double.parse(
                                                showAddressController
                                                        .addressZoneModel
                                                        .value
                                                        .data
                                                        ?.longitude ??
                                                    '',
                                              );

                                              cartController.calculateDistance(
                                                addressLat,
                                                addressLong,
                                                branchLat,
                                                branchLong,
                                              );

                                              cartController
                                                  .distanceWiseDeliveryCharge(
                                                    chargePerKilo: double.parse(
                                                      showAddressController
                                                          .addressZoneModel
                                                          .value
                                                          .data!
                                                          .deliveryChargePerKilo
                                                          .toString(),
                                                    ),
                                                  );
                                            }
                                          } else {
                                            showAddressController
                                                .setSelectedAddressIndex(-1);
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.h,
                                        ),
                                        child: Obx(
                                          () => Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  showAddressController
                                                              .selectedAddressIndex
                                                              .value ==
                                                          index
                                                      ? AppColor.primaryColor1
                                                      : AppColor.addressColor,
                                              border: Border.all(
                                                color:
                                                    showAddressController
                                                                .selectedAddressIndex
                                                                .value ==
                                                            index
                                                        ? AppColor.primaryColor
                                                        : Colors.transparent,
                                                width: 1.r,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.r),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    showAddressController
                                                                .selectedAddressIndex
                                                                .value ==
                                                            index
                                                        ? SvgIcon.radioActive
                                                        : SvgIcon.radio,
                                                    color:
                                                        showAddressController
                                                                    .selectedAddressIndex
                                                                    .value ==
                                                                index
                                                            ? AppColor
                                                                .primaryColor
                                                            : null,
                                                    height: 16.h,
                                                    width: 16.w,
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  Obx(
                                                    () =>
                                                        showAddressController
                                                                    .addressList
                                                                    .value
                                                                    .data ==
                                                                null
                                                            ? const Center(
                                                              child: SizedBox(),
                                                            )
                                                            : AddressCard(
                                                              label:
                                                                  address?[index]
                                                                      .label ??
                                                                  "",
                                                              streetAddress:
                                                                  "${showAddressController.addressList.value.data?[index].apartment == null ? "" : "${showAddressController.addressList.value.data?[index].apartment},"} ${showAddressController.addressList.value.data?[index].address.toString()}",
                                                            ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                  SizedBox(height: 24.h),
                  const DeviderWidget(),
                  SizedBox(height: 24.h),
                  !isFileAttached()
                      ? SizedBox()
                      : Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.borderColor.withAlpha(150),
                                  offset: Offset(1, 1),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 16.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextWidget(
                                        text: 'FILE_ATTACHMENT'.tr,
                                        color: AppColor.textColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      SizedBox(width: 8.w),
                                      TextWidget(text: 'UP_TO_5_IMAGES'.tr),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Obx(
                                    () =>
                                        showAddressController
                                                    .imageList
                                                    .length >=
                                                5
                                            ? SizedBox()
                                            : GestureDetector(
                                              onTap: () {
                                                showAddressController
                                                    .pickImages();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                ),
                                                child: DottedBorder(
                                                  color: Colors.black.withAlpha(
                                                    150,
                                                  ),
                                                  borderType: BorderType.RRect,
                                                  radius: Radius.circular(8.r),
                                                  strokeWidth: 1,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 32.h,
                                                          ),
                                                      child: Column(
                                                        children: [
                                                          TextWidget(
                                                            text:
                                                                'DROP_YOUR_IMAGE_HERE_OR'
                                                                    .tr,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          TextWidget(
                                                            text: 'BROWSE'.tr,
                                                            fontSize: 14.sp,
                                                            color:
                                                                AppColor
                                                                    .activeColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          TextWidget(
                                                            text:
                                                                'SUPPORT_JPEG_JPG_AND_PNG_MAX_SIZE_IS_2MB'
                                                                    .tr,
                                                            fontSize: 12.sp,
                                                            color:
                                                                AppColor
                                                                    .black60,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  ),
                                  SizedBox(height: 24.h),
                                  buildImageGrid(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                  InkWell(
                    onTap: () {
                      openCoupon();
                    },
                    child: Obx(
                      () => Container(
                        height: 67.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color:
                                couponController.applyCouponStatus.value == true
                                    ? AppColor.greenColor
                                    : AppColor.blueBorderColor,
                            width: 1.r,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      SvgIcon.coupon,
                                      color:
                                          couponController
                                                      .applyCouponStatus
                                                      .value ==
                                                  true
                                              ? AppColor.primaryColor
                                              : null,
                                      height: 24.h,
                                      width: 24.h,
                                    ),
                                    SizedBox(width: 12.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        couponController
                                                    .applyCouponStatus
                                                    .value ==
                                                false
                                            ? TextWidget(
                                              text:
                                                  'Apply Promo, Coupon or Voucher'
                                                      .tr,
                                              color: AppColor.blueBorderColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                            :
                                            //after coupon applied
                                            TextWidget(
                                              text: 'Coupon Applied'.tr,
                                              color: AppColor.greenColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        SizedBox(height: 4.h),
                                        couponController
                                                    .applyCouponStatus
                                                    .value ==
                                                false
                                            ? TextWidget(
                                              text:
                                                  'Get discount with your order'
                                                      .tr,
                                              color: AppColor.textColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            )
                                            : TextWidget(
                                              text:
                                                  'You saved'.tr +
                                                  ' ${authController.settingModel!.data!.siteDefaultCurrencySymbol.toString()}${couponController.applyCouponModel.value.data?.convertDiscount!.toStringAsFixed(int.parse(authController.settingModel!.data!.siteDigitAfterDecimalPoint.toString())) ?? 0.0}',
                                              color: AppColor.textColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ],
                                    ),
                                  ],
                                ),
                                couponController.applyCouponStatus.value ==
                                        false
                                    ? SvgPicture.asset(
                                      SvgIcon.forwardCoupon,
                                      height: 24.h,
                                      width: 24.h,
                                    )
                                    : InkWell(
                                      onTap: () {
                                        box.write("applyCoupon", false);
                                        couponController
                                            .applyCouponStatus
                                            .value = box.read("applyCoupon");
                                      },
                                      child: SvgPicture.asset(
                                        SvgIcon.remove,
                                        height: 24.h,
                                        width: 24.h,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Obx(() {
                    return OrderSummay(
                      subTotal: cartController.totalPrice,
                      tax: cartController.totalTax,
                      shippingCharge:
                          isDelivery == false ||
                                  showAddressController.zoneStatus.value ==
                                      false
                              ? "0"
                              : cartController.deliveryCharge.toString(),
                      discount:
                          couponController.applyCouponStatus.value == false
                              ? 0
                              : couponController
                                      .applyCouponModel
                                      .value
                                      .data
                                      ?.convertDiscount ??
                                  "0",
                      total:
                          cartController.totalPrice > 0 &&
                                  couponController.applyCouponStatus.value ==
                                      true
                              ? ((cartController.totalPrice +
                                      cartController.totalTax +
                                      (isDelivery == false ||
                                              showAddressController
                                                      .zoneStatus
                                                      .value ==
                                                  false
                                          ? 0
                                          : cartController.deliveryCharge)) -
                                  (double.parse(
                                    couponController
                                        .applyCouponModel
                                        .value
                                        .data!
                                        .convertDiscount
                                        .toString(),
                                  )))
                              : (cartController.totalPrice +
                                      cartController.totalTax) +
                                  (isDelivery == false ||
                                          showAddressController
                                                  .zoneStatus
                                                  .value ==
                                              false
                                      ? 0
                                      : (cartController.deliveryCharge)),
                      onTap:
                          isDelivery == true &&
                                  cartController.totalPrice <
                                      double.parse(
                                        showAddressController
                                                .addressZoneModel
                                                .value
                                                .data
                                                ?.minimumOrderAmount
                                                .toString() ??
                                            "0",
                                      )
                              ? null
                              : () {
                                if (isFileAttached() == true &&
                                    showAddressController.imageList.isEmpty) {
                                  customSnackbar(
                                    "ERROR".tr,
                                    "File Attachment is required.".tr,
                                    AppColor.error,
                                  );

                                  return;
                                }
                                if (isDelivery == true) {
                                  if (showAddressController
                                          .selectedAddressIndex
                                          .value ==
                                      -1) {
                                    customSnackbar(
                                      "ERROR".tr,
                                      "The delivery address is required.".tr,
                                      AppColor.error,
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => PaymentScreen(isDelivery),
                                      ),
                                    );
                                  }
                                } else if (isDelivery == false) {
                                  if (showAddressController
                                          .selectedOutletIndex
                                          .value ==
                                      -1) {
                                    customSnackbar(
                                      "ERROR".tr,
                                      "Outlet is required.".tr,
                                      AppColor.error,
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => PaymentScreen(isDelivery),
                                      ),
                                    );
                                  }
                                }
                              },
                      buttonColor:
                          cartController.totalPrice <
                                      double.parse(
                                        showAddressController
                                                .addressZoneModel
                                                .value
                                                .data
                                                ?.minimumOrderAmount
                                                .toString() ??
                                            "0",
                                      ) &&
                                  isDelivery == true
                              ? AppColor.primaryColor.withOpacity(0.5)
                              : AppColor.primaryColor,
                      buttonText: "Save & Pay".tr,
                      optionalText:
                          cartController.totalPrice <
                                      double.parse(
                                        showAddressController
                                                .addressZoneModel
                                                .value
                                                .data
                                                ?.minimumOrderAmount
                                                .toString() ??
                                            "0",
                                      ) &&
                                  isDelivery == true
                              ? "MINIMUM_ORDER".trParams({
                                'amount':
                                    showAddressController
                                        .addressZoneModel
                                        .value
                                        .data!
                                        .currencyMinimumOrderAmount
                                        .toString(),
                              })
                              : "",
                    );
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      customSnackbar("ERROR".tr, "LOCATION_SERVICE_DENIED".tr, AppColor.error);
    } else if (permission == LocationPermission.deniedForever) {
      permissionAlert(context).show();
    } else {
      onTap();
    }
  }
}
