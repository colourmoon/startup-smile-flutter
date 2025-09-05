// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:ebazaar/utils/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../config/theme/app_color.dart';
import '../../../../../data/model/address_list_model.dart';
import '../../../../../utils/constant.dart';
import '../../controller/address_controller.dart';

class EditBottomSheetAddress extends StatefulWidget {
  AddressListData? addressData;
  EditBottomSheetAddress({
    super.key,
    this.addressData,
  });
  @override
  State<EditBottomSheetAddress> createState() => _EditAddressViewState();
}

class _EditAddressViewState extends State<EditBottomSheetAddress> {
  final TextEditingController labelController = TextEditingController();

  TextEditingController appartmentController = TextEditingController();
  AddressController addressController = Get.put(AddressController());

  final iconList = [SvgIcon.home, SvgIcon.work, SvgIcon.other];

  @override
  void initState() {
    addressController.selectLabel.value = widget.addressData?.label ?? "";

    if (widget.addressData!.label! != addressController.addressTypeList[0] &&
        widget.addressData!.label! != addressController.addressTypeList[1]) {
      labelController.text = widget.addressData?.label ?? "";
      addressController.selectLabel.value =
          addressController.addressTypeList[2];
    }
    addressController.pickAddress = widget.addressData!.address.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.addressData!.apartment == null) {
      appartmentController.text = "";
    } else {
      appartmentController.text = widget.addressData!.apartment!;
    }

    return SafeArea(
      child: GetBuilder<AddressController>(
        builder: (addressController) => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.grayColor.withOpacity(0.5),
                offset: const Offset(
                  0.0,
                  6.0,
                ),
                blurRadius: 30.r,
                spreadRadius: 10.r,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: SvgPicture.asset(
                        SvgIcon.menuLocation,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 13.w,
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        width: 290.w,
                        child: Text(
                          addressController.pickAddress.toString(),
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "APPARTMENT_&_FLAT_NO".tr,
                    style: fontRegular,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  SizedBox(
                    child: TextField(
                      controller: appartmentController,
                      expands: false,
                      decoration: InputDecoration(
                        fillColor: AppColor.borderColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0.r)),
                          borderSide: BorderSide(
                              color: AppColor.borderColor, width: 2.0.w),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0.r)),
                          borderSide: BorderSide(
                              width: 2.w, color: AppColor.borderColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ADD_LABEL".tr,
                    style: fontMedium,
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  SizedBox(
                    height: 50.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: addressController.addressTypeList.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                addressController.selectLabel.value =
                                    addressController.addressTypeList[index];
                              },
                              child: Column(
                                children: [
                                  Obx(
                                    () => addressController.selectLabel.value ==
                                            "-1"
                                        ? const SizedBox()
                                        : Container(
                                            height: 48.h,
                                            width: 88.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              color: addressController
                                                          .selectLabel.value ==
                                                      addressController
                                                              .addressTypeList[
                                                          index]
                                                  ? AppColor.primaryColor
                                                      .withOpacity(0.08)
                                                  : AppColor.borderColor,
                                              border: addressController
                                                          .selectLabel.value ==
                                                      addressController
                                                              .addressTypeList[
                                                          index]
                                                  ? Border.all(
                                                      color:
                                                          AppColor.primaryColor)
                                                  : Border.all(
                                                      color: Colors.white),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20.w,
                                                  height: 20.h,
                                                  child: SvgPicture.asset(
                                                    iconList[index],
                                                    fit: BoxFit.cover,
                                                    color: addressController
                                                                    .addressTypeList[
                                                                index] ==
                                                            widget.addressData!
                                                                .label!
                                                        ? null
                                                        : AppColor.iconColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                Text(
                                                  addressController
                                                      .addressTypeList[index],
                                                  style: fontMediumPro,
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  Obx(
                    () => addressController.selectLabel.value !=
                            addressController.addressTypeList[2]
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              child: TextField(
                                controller: labelController,
                                expands: false,
                                decoration: InputDecoration(
                                  fillColor: AppColor.borderColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0.r)),
                                    borderSide: BorderSide(
                                        color: AppColor.borderColor,
                                        width: 2.0.w),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0.r)),
                                    borderSide: BorderSide(
                                        width: 2.w,
                                        color: AppColor.borderColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await addressController.updateAddress(
                            widget.addressData!.id.toString(),
                            addressController.selectLabel.value ==
                                    addressController.addressTypeList[2]
                                ? labelController.text
                                : addressController.selectLabel.value,
                            appartmentController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        minimumSize: Size(328.w, 52.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        "UPDATE_LOCATION".tr,
                        style: fontMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
