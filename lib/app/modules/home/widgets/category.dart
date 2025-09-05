import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebazaar/app/modules/category/views/category_wise_product_screen.dart';
import 'package:ebazaar/app/modules/home/controller/category_controller.dart';
import 'package:ebazaar/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return Container(
      height: 120.h,
      width: double.infinity,
      color: AppColor.whiteColor, // white hobe
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categoryController.categoryModel.value.data!.length,
          itemBuilder: (context, index) {
            final category = categoryController.categoryModel.value.data!;
            return Center(
              child: Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => CategoryWiseProductScreen(
                        categoryModel: category[index],
                      ),
                    );
                  },
                  child: Container(
                    height: 84.h,
                    width: 84.w,
                    decoration: BoxDecoration(
                      color: AppColor.cartColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 12.h,
                        bottom: 12.h,
                        left: 2.w,
                        right: 2.w,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CachedNetworkImage(
                            imageUrl: category[index].thumb.toString(),
                            imageBuilder:
                                (context, imageProvider) => Container(
                                  height: 35.h,
                                  width: 45.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                          ),
                          TextWidget(
                            text: category[index].name,
                            textAlign: TextAlign.center,
                            color: AppColor.titleTextColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
