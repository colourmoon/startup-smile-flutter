import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebazaar/app/modules/auth/controller/auth_controler.dart';
import 'package:ebazaar/app/modules/order/controller/order_controller.dart';
import 'package:ebazaar/app/modules/order/views/print_invoice.dart';
import 'package:ebazaar/app/modules/order/widgets/order2.dart';
import 'package:ebazaar/app/modules/shipping/widgets/order_processing.dart';
import 'package:ebazaar/main.dart';
import 'package:ebazaar/utils/svg_icon.dart';
import 'package:ebazaar/widgets/appbar3.dart';
import 'package:ebazaar/widgets/loader/loader.dart';
import 'package:ebazaar/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';
import '../../shipping/widgets/order_processing_pickup.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, this.id});
  final String? id;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderController order = Get.put(OrderController());
  AuthController authController = Get.put(AuthController());

  String shippingAddress = '';
  String billingAddress = '';
  String outletAddress = '';

  @override
  void initState() {
    super.initState();
    if (box.read('isLogedIn') != false) {
      order.getOrderDetails(id: widget.id.toString());
      authController.getSetting();
    }
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
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              backgroundColor: AppColor.primaryBackgroundColor,
              appBar: AppBarWidget3(text: 'Order Details'.tr),
              body: Obx(() {
                if (order.orderDetailsMap.isNotEmpty &&
                    authController.settingMap.isNotEmpty) {
                  if (order.orderDetailsModel?.data?.outletAddress == null) {
                    shippingAddress =
                        '${order.orderDetailsModel?.data?.orderAddress?.apartment == null || order.orderDetailsModel?.data?.orderAddress?.apartment == '' ? '' : '${order.orderDetailsModel?.data?.orderAddress?.apartment}, '}${order.orderDetailsModel?.data?.orderAddress?.address}'
                        "";
                  } else if (order.orderDetailsModel!.data!.outletAddress !=
                      null) {
                    outletAddress =
                        '${order.orderDetailsModel?.data?.outletAddress?.address}'
                        "";
                  }
                  return RefreshIndicator(
                    color: AppColor.primaryColor,
                    onRefresh: () async {
                      if (box.read('isLogedIn') != false) {
                        order.getOrderDetails(id: widget.id.toString());
                        authController.getSetting();
                      }
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 16.h,
                          left: 16.w,
                          right: 16.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 22.h),
                            TextWidget(
                              text: 'Thank You'.tr,
                              color: AppColor.textColor,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 12.h),
                            TextWidget(
                              text: 'Your Order status is as follows'.tr,
                              color: AppColor.textColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Order ID: '.tr,
                                  color: AppColor.textColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text:
                                      '#${order.orderDetailsModel?.data?.orderSerialNo.toString() ?? ""}',
                                  color: AppColor.primaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            order.orderDetailsModel?.data?.status == 25
                                ? Container(
                                    height: 62.h,
                                    width: 240.w,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: AppColor.redColor,
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            SvgIcon.close,
                                            height: 20.h,
                                            width: 20.w,
                                          ),
                                          SizedBox(width: 6.w),
                                          TextWidget(
                                            text: 'Order Returned'.tr,
                                            color: AppColor.error,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : order.orderDetailsModel?.data?.status == 15 ||
                                      order.orderDetailsModel?.data?.status ==
                                          20
                                ? Container(
                                    height: 62.h,
                                    width: 240.w,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: AppColor.redColor,
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            SvgIcon.close,
                                            height: 20.h,
                                            width: 20.w,
                                          ),
                                          SizedBox(width: 6.w),
                                          TextWidget(
                                            text:
                                                order
                                                        .orderDetailsModel!
                                                        .data!
                                                        .status ==
                                                    15
                                                ? 'Order Canceled'.tr
                                                : 'Order Rejected'.tr,
                                            color: AppColor.error,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      order
                                                  .orderDetailsModel!
                                                  .data!
                                                  .orderType ==
                                              5
                                          ? OrderProcesingWidget(
                                              order:
                                                  order.orderDetailsModel!.data,
                                            )
                                          : OrderProcesingPickupWidget(
                                              order:
                                                  order.orderDetailsModel!.data,
                                            ),
                                    ],
                                  ),
                            SizedBox(height: 32.h),
                            Container(
                              //  height: 157.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                border: Border.all(
                                  color: AppColor.borderColor,
                                  width: 1.r,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: 'Order ID:'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 8.h),
                                          TextWidget(
                                            text: 'Order Date:'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 8.h),
                                          TextWidget(
                                            text: 'Order Type:'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 8.h),
                                          TextWidget(
                                            text: 'Order Status:'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 8.h),
                                          TextWidget(
                                            text: 'Payment Status:'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 8.h),
                                          TextWidget(
                                            text: 'Payment Type:'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 6.h),
                                          order
                                                      .orderDetailsModel
                                                      ?.data
                                                      ?.transaction !=
                                                  null
                                              ? order
                                                                .orderDetailsModel
                                                                ?.data
                                                                ?.editedAmount !=
                                                            0 &&
                                                        (order
                                                                .orderDetailsModel
                                                                ?.data
                                                                ?.transaction !=
                                                            0)
                                                    ? TextWidget(
                                                        text: 'NOTE:'.tr,
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )
                                                    : const SizedBox()
                                              : const SizedBox(),
                                          SizedBox(height: 6.h),
                                          order
                                                          .orderDetailsModel
                                                          ?.data
                                                          ?.reason !=
                                                      null &&
                                                  order
                                                          .orderDetailsModel
                                                          ?.data
                                                          ?.status ==
                                                      25
                                              ? TextWidget(
                                                  text: 'RETURN_ORDER_NOTE:'.tr,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              TextWidget(
                                                text:
                                                    '#${order.orderDetailsModel?.data?.orderSerialNo}',
                                                color: AppColor.textColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(width: 8.w),
                                              order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .editedDate ==
                                                      null
                                                  ? const SizedBox()
                                                  : TextWidget(
                                                      text: '(Edited)'.tr,
                                                      color: AppColor.redColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
                                          TextWidget(
                                            text: order
                                                .orderDetailsModel!
                                                .data!
                                                .orderDatetime,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(height: 6.h),
                                          TextWidget(
                                            text:
                                                order
                                                        .orderDetailsModel!
                                                        .data!
                                                        .orderType ==
                                                    5
                                                ? 'Delivery'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .orderType ==
                                                      10
                                                ? 'Pickup'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .orderType ==
                                                      15
                                                ? 'POS'.tr
                                                : '',
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(height: 6.h),
                                          TextWidget(
                                            text:
                                                order
                                                        .orderDetailsModel!
                                                        .data!
                                                        .status ==
                                                    1
                                                ? 'Pending'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      5
                                                ? 'Confirmed'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      7
                                                ? 'On The Way'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      10
                                                ? 'Delivered'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      15
                                                ? 'Cenceled'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      20
                                                ? 'Rejected'.tr
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      25
                                                ? "Order Returned".tr
                                                : '',
                                            color:
                                                order
                                                        .orderDetailsModel!
                                                        .data!
                                                        .status ==
                                                    1
                                                ? AppColor.pendingColor
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      5
                                                ? AppColor.primaryColor
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      7
                                                ? AppColor.onthewayColor
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      10
                                                ? AppColor.greenColor
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      15
                                                ? AppColor.redColor2
                                                : order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .status ==
                                                      20
                                                ? AppColor.redColor2
                                                : AppColor.redColor2,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 6.h),
                                          Container(
                                            width:
                                                order
                                                        .orderDetailsModel!
                                                        .data!
                                                        .paymentStatus ==
                                                    5
                                                ? 40.w
                                                : 60.w,
                                            decoration: BoxDecoration(
                                              color:
                                                  order
                                                          .orderDetailsModel!
                                                          .data!
                                                          .paymentStatus ==
                                                      5
                                                  ? AppColor.paidColor
                                                  : order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .paymentStatus ==
                                                        10
                                                  ? AppColor.unpaidColor
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(4.r),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 2.h,
                                                    left: 2.w,
                                                    bottom: 2.h,
                                                    right: 2.w,
                                                  ),
                                                  child: FittedBox(
                                                    child: TextWidget(
                                                      text:
                                                          order
                                                                  .orderDetailsModel!
                                                                  .data!
                                                                  .paymentStatus ==
                                                              5
                                                          ? 'Paid'.tr
                                                          : order
                                                                    .orderDetailsModel!
                                                                    .data!
                                                                    .paymentStatus ==
                                                                10
                                                          ? 'Unpaid'.tr
                                                          : '',
                                                      color:
                                                          order
                                                                  .orderDetailsModel!
                                                                  .data!
                                                                  .paymentStatus ==
                                                              5
                                                          ? AppColor.greenColor
                                                          : order
                                                                    .orderDetailsModel!
                                                                    .data!
                                                                    .paymentStatus ==
                                                                10
                                                          ? AppColor.redColor2
                                                          : null,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          TextWidget(
                                            text: order
                                                .orderDetailsModel!
                                                .data!
                                                .paymentMethodName,
                                            color: AppColor.textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(height: 6.h),
                                          order
                                                      .orderDetailsModel
                                                      ?.data
                                                      ?.transaction !=
                                                  null
                                              ? order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .editedAmount !=
                                                            0 &&
                                                        order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .transaction !=
                                                            0
                                                    ? order
                                                                  .orderDetailsModel!
                                                                  .data!
                                                                  .editedAmount! >=
                                                              0
                                                          ? TextWidget(
                                                              text: "NOTE_DUE_AMOUNT".trParams({
                                                                "amount": order
                                                                    .orderDetailsModel!
                                                                    .data!
                                                                    .editedCurrencyAmount
                                                                    .toString(),
                                                              }).tr,
                                                              maxLines: 1,
                                                              color: AppColor
                                                                  .blueColor,
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )
                                                          : TextWidget(
                                                              text: "NOTE_RETURN_AMOUNT".trParams({
                                                                "amount": order
                                                                    .orderDetailsModel!
                                                                    .data!
                                                                    .editedCurrencyAmount
                                                                    .toString(),
                                                              }).tr,
                                                              maxLines: 1,
                                                              color: AppColor
                                                                  .blueColor,
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )
                                                    : const SizedBox()
                                              : const SizedBox(),
                                          SizedBox(height: 6.h),
                                          order
                                                          .orderDetailsModel
                                                          ?.data
                                                          ?.reason !=
                                                      null &&
                                                  order
                                                          .orderDetailsModel
                                                          ?.data
                                                          ?.status ==
                                                      25
                                              ? TextWidget(
                                                  text: order
                                                      .orderDetailsModel
                                                      ?.data
                                                      ?.reason,
                                                  maxLines: 1,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            order.orderDetailsModel?.data?.orderAddress ==
                                        null ||
                                    order
                                            .orderDetailsModel!
                                            .data!
                                            .orderAddress!
                                            .address!
                                            .isEmpty &&
                                        order
                                                .orderDetailsModel!
                                                .data!
                                                .outletAddress !=
                                            null
                                ? Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      border: Border.all(
                                        color: AppColor.borderColor,
                                        width: 1.r,
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.r),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: 'Name:'.tr,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .phone
                                                                .toString() ==
                                                            '' &&
                                                        order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .countryCode
                                                                .toString() ==
                                                            ''
                                                    ? SizedBox()
                                                    : SizedBox(height: 12.h),
                                                order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .phone
                                                                .toString() ==
                                                            '' &&
                                                        order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .countryCode
                                                                .toString() ==
                                                            ''
                                                    ? SizedBox()
                                                    : TextWidget(
                                                        text: 'Phone:'.tr,
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .outletAddress!
                                                            .email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : SizedBox(height: 12.h),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .outletAddress!
                                                            .email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : TextWidget(
                                                        text: 'Email:'.tr,
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                SizedBox(height: 12.h),
                                                TextWidget(
                                                  text: 'Outlet Address:'.tr,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: order
                                                      .orderDetailsModel!
                                                      .data!
                                                      .outletAddress!
                                                      .name
                                                      .toString(),
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .phone
                                                                .toString() ==
                                                            '' &&
                                                        order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .countryCode
                                                                .toString() ==
                                                            ''
                                                    ? SizedBox()
                                                    : SizedBox(height: 12.h),
                                                order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .phone
                                                                .toString() ==
                                                            '' &&
                                                        order
                                                                .orderDetailsModel!
                                                                .data!
                                                                .outletAddress!
                                                                .countryCode
                                                                .toString() ==
                                                            ''
                                                    ? SizedBox()
                                                    : TextWidget(
                                                        text:
                                                            '${order.orderDetailsModel!.data!.outletAddress!.countryCode.toString()}${order.orderDetailsModel!.data!.outletAddress!.phone.toString()}',
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .outletAddress!
                                                            .email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : SizedBox(height: 12.h),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .outletAddress!
                                                            .email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : TextWidget(
                                                        text: order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .outletAddress!
                                                            .email
                                                            .toString(),
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                SizedBox(height: 12.h),
                                                TextWidget(
                                                  text: order
                                                      .orderDetailsModel!
                                                      .data!
                                                      .outletAddress!
                                                      .address
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 12.h),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : order
                                      .orderDetailsModel!
                                      .data!
                                      .orderAddress!
                                      .address!
                                      .isNotEmpty
                                ? Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      border: Border.all(
                                        color: AppColor.borderColor,
                                        width: 1.r,
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.r),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: 'Name:'.tr,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                SizedBox(height: 12.h),
                                                TextWidget(
                                                  text: 'Phone:'.tr,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .user
                                                            ?.email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : SizedBox(height: 12.h),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .user
                                                            ?.email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : TextWidget(
                                                        text: 'Email:'.tr,
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                SizedBox(height: 12.h),
                                                Row(
                                                  children: [
                                                    TextWidget(
                                                      text:
                                                          'DELIVERY_ADDRESS'.tr,
                                                      color: AppColor.textColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    TextWidget(
                                                      text: ':'.tr,
                                                      color: AppColor.textColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: order
                                                      .orderDetailsModel!
                                                      .data!
                                                      .user
                                                      ?.name,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                SizedBox(height: 12.h),
                                                TextWidget(
                                                  text:
                                                      '${order.orderDetailsModel!.data!.user?.countryCode}${order.orderDetailsModel!.data!.user?.phone}',
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .user
                                                            ?.email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : SizedBox(height: 12.h),
                                                order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .user
                                                            ?.email
                                                            .toString() ==
                                                        ''
                                                    ? SizedBox()
                                                    : TextWidget(
                                                        text: order
                                                            .orderDetailsModel!
                                                            .data!
                                                            .user
                                                            ?.email,
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                SizedBox(height: 12.h),
                                                TextWidget(
                                                  text:
                                                      '${order.orderDetailsModel?.data?.orderAddress?.apartment == null || order.orderDetailsModel?.data?.orderAddress?.apartment == '' ? '' : '${order.orderDetailsModel?.data?.orderAddress?.apartment}, '}${order.orderDetailsModel?.data?.orderAddress?.address}',
                                                  textAlign: TextAlign.left,
                                                  color: AppColor.textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 12.h),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            order.orderDetailsModel?.data?.orderAddress ==
                                        null ||
                                    order
                                        .orderDetailsModel!
                                        .data!
                                        .orderAddress!
                                        .address!
                                        .isEmpty
                                ? SizedBox()
                                : SizedBox(height: 16.h),
                            SizedBox(height: 24.h),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                border: Border.all(
                                  color: AppColor.borderColor,
                                  width: 1.r,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 16.h,
                                  bottom: 16.h,
                                ),
                                child: Column(
                                  children: [
                                    TextWidget(
                                      text: 'Order Summary'.tr,
                                      color: AppColor.textColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(height: 16.h),
                                    DottedLine(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      lineLength: double.infinity,
                                      lineThickness: 1.sp,
                                      dashLength: 4.w,
                                      dashColor: AppColor.borderColor,
                                      dashGapLength: 4.w,
                                      dashGapColor: Colors.transparent,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                      ),
                                      child: ListView.builder(
                                        itemCount: order
                                            .orderDetailsModel!
                                            .data!
                                            .orderProducts!
                                            .length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return OrderWidget2(
                                            product: order
                                                .orderDetailsModel!
                                                .data!
                                                .orderProducts![index],
                                            order:
                                                order.orderDetailsModel!.data,
                                          );
                                        },
                                      ),
                                    ),
                                    DottedLine(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      lineLength: double.infinity,
                                      lineThickness: 1.sp,
                                      dashLength: 4.w,
                                      dashColor: AppColor.borderColor,
                                      dashGapLength: 4.w,
                                      dashGapColor: Colors.transparent,
                                    ),
                                    SizedBox(height: 16.h),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: 'Subtotal'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          TextWidget(
                                            text: order
                                                .orderDetailsModel!
                                                .data!
                                                .subtotalCurrencyPrice,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: 'Tax'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          TextWidget(
                                            text: order
                                                .orderDetailsModel!
                                                .data!
                                                .taxCurrencyPrice,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: 'Delivery Charge'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          TextWidget(
                                            text: order
                                                .orderDetailsModel!
                                                .data!
                                                .shippingChargeCurrencyPrice,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: 'Discount'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          TextWidget(
                                            text: order
                                                .orderDetailsModel!
                                                .data!
                                                .discountCurrencyPrice,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    DottedLine(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      lineLength: double.infinity,
                                      lineThickness: 1.sp,
                                      dashLength: 4.w,
                                      dashColor: AppColor.borderColor,
                                      dashGapLength: 4.w,
                                      dashGapColor: Colors.transparent,
                                    ),
                                    SizedBox(height: 16.h),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: 'Total'.tr,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          TextWidget(
                                            text: order
                                                .orderDetailsModel!
                                                .data!
                                                .totalCurrencyPrice,
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(outletAddress);
                                    print(shippingAddress);
                                    Get.to(
                                      () => PrintInvoice(
                                        orderDetails:
                                            order.orderDetailsModel!.data,
                                        comapnyInfo:
                                            authController.settingModel!.data,
                                        address:
                                            order
                                                    .orderDetailsModel!
                                                    .data!
                                                    .orderType
                                                    .toString() ==
                                                '10'
                                            ? outletAddress
                                            : shippingAddress,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 48.h,
                                    width: 171.w,
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor,
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    child: Center(
                                      child: TextWidget(
                                        text: 'Download Receipt'.tr,
                                        color: AppColor.whiteColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                order.orderDetailsModel!.data!.status == 1
                                    ? InkWell(
                                        onTap: () {
                                          order.cancelOrder(
                                            order_id: order
                                                .orderDetailsModel!
                                                .data!
                                                .id
                                                .toString(),
                                          );
                                        },
                                        child: Container(
                                          height: 48.h,
                                          width: 136.w,
                                          decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            border: Border.all(
                                              color: AppColor.redColor,
                                              width: 1.w,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              24.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: TextWidget(
                                              text: 'Cancel Order'.tr,
                                              color: AppColor.redColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: LoaderCircle());
                }
              }),
            ),
            order.isLoading.value ? const LoaderCircle() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
