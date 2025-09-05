import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme/app_color.dart';

class CustomPhoneFormField extends StatefulWidget {
  const CustomPhoneFormField(
      {super.key, this.phoneController, this.validator, this.prefix});

  final TextEditingController? phoneController;
  final Widget? prefix;
  final String? Function(String?)? validator;

  @override
  State<CustomPhoneFormField> createState() => _CustomPhoneFormField();
}

class _CustomPhoneFormField extends State<CustomPhoneFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        style: GoogleFonts.urbanist(
            color: AppColor.textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500),
        controller: widget.phoneController,
        cursorColor: AppColor.textColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Padding(
            padding: EdgeInsets.only(
                left: 10.w, top: 15.h, bottom: 11.h, right: 8.w),
            child: SizedBox(
              child: widget.prefix,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.inactiveColor),
            borderRadius: BorderRadius.circular(8.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.inactiveColor),
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.inactiveColor),
            borderRadius: BorderRadius.circular(8.r),
          ),
          hintStyle: GoogleFonts.urbanist(
              color: AppColor.textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
        validator: widget.validator,
      ),
    );
  }
}
