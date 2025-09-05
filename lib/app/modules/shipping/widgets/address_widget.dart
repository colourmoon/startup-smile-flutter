import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/textwidget.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.label,
    required this.streetAddress,
  });

  final String label;
  final String streetAddress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: label,
            color: AppColor.textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          TextWidget(
            text: streetAddress,
            color: AppColor.textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            maxLines: 3,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
