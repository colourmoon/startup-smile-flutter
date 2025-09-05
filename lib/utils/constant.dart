import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theme/app_color.dart';

const String regularExpressionEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

const sortByList = [
  "Newest",
  "Price Low To High",
  "Price High To Low",
  "Top Rated",
];

class Dimensions {
  static double fontSizeExtraSmallSamll = 8;
  static double fontSizeExtraSmall = 10;
  static double fontSizeSmall = 12;
  static double fontSizeDefault = 14;
  static double fontSizeReasonHeading = 14;
  static double fontSizeReasonText = 12;
  static double fontSizeLarge = 16;
  static double fontSizeExtraLarge = 18;
  static double fontSizeExtraLarge22 = 22;
  static double fontSizeOverLarge = 26;
}

final fontRegularBold = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

final fontRegular = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeSmall.sp,
);
final fontMedium = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeLarge.sp,
);
final fontMediumPro = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeDefault.sp,
);

final fontMediumProWhite = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontSize: Dimensions.fontSizeDefault.sp,
);
final fontRegularWithColor = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w400,
  color: AppColor.primaryColor,
  fontSize: Dimensions.fontSizeSmall.sp,
);
