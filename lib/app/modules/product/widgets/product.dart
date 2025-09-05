import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebazaar/widgets/textwidget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    this.title,
    this.textRating,
    this.discountPrice,
    this.currentPrice,
    this.rating,
    this.productImage,
    this.onTap,
    this.favTap,
    this.flashSale,
    this.isOffer,
    this.favColor,
    this.wishlist,
    this.reviews,
    this.unit,
  });
  final String? productImage;
  final String? title;
  final int? textRating;
  final String? reviews;
  final String? discountPrice;
  final String? currentPrice;
  final String? rating;
  final void Function()? onTap;
  final void Function()? favTap;

  final bool? flashSale;
  final bool? isOffer;
  final String? favColor;
  final bool? wishlist;
  final String? unit;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156.w,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.borderColor, width: 0.75.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: productImage.toString(),
                  imageBuilder:
                      (context, imageProvider) => Container(
                        height: 160.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                ),
                Positioned(
                  left: 6.w,
                  right: 6.w,
                  top: 6.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      wishlist == false
                          ? InkWell(
                            onTap: favTap,
                            child: Container(
                              height: 18.r,
                              width: 18.r,
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgIcon.heart,
                                  height: 12.h,
                                  width: 12.w,
                                ),
                              ),
                            ),
                          )
                          : InkWell(
                            onTap: favTap,
                            child: Container(
                              height: 18.r,
                              width: 18.r,
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgIcon.filledHeart,
                                  height: 12.h,
                                  width: 12.w,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8.w,
                  bottom: 8.h,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              SvgIcon.bag2,
                              height: 12.h,
                              width: 12.w,
                            ),
                            SizedBox(width: 4.w),
                            TextWidget(
                              text: 'Add'.tr,
                              color: AppColor.whiteColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            SizedBox(
              child: TextWidget(
                text: title ?? '',
                color: AppColor.textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              child: TextWidget(
                text: unit ?? '',
                color: AppColor.textColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.h),
            FittedBox(
              child: Row(
                children: [
                  isOffer == false
                      ? TextWidget(
                        text: currentPrice ?? '0',
                        color: AppColor.primaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      )
                      : SizedBox(),
                  SizedBox(width: isOffer == false ? 8.w : 0),
                  isOffer == true
                      ? Row(
                        children: [
                          TextWidget(
                            text: discountPrice ?? '0',
                            color: AppColor.textColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(width: 8.w),
                          TextWidget(
                            text: currentPrice ?? '0',
                            color: AppColor.redColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ],
                      )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
