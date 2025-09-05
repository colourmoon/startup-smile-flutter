import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebazaar/app/modules/auth/controller/auth_controler.dart';
import 'package:ebazaar/app/modules/auth/views/sign_in.dart';
import 'package:ebazaar/utils/validation_rules.dart';
import 'package:ebazaar/widgets/appbar3.dart';
import 'package:ebazaar/widgets/loader/loader.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../main.dart';
import '../../../../widgets/custom_form_field.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/form_field_title.dart';
import '../../../../widgets/primary_button.dart';
import '../controller/swap_title_controller.dart';
import '../widgets/swap_field_title.dart';
import '../widgets/swap_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authController = Get.put(AuthController());
  final swapController = Get.put(SwapTitleController());

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController.nameController.clear();
    authController.emailController.clear();
    authController.passController.clear();
    authController.phoneController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authController.getSetting();
      await authController.getCountryCode();
      await authController.getCallingCode();
      authController.countryCode = box.read("callingCode") ?? "";
      box.write('country_code', authController.countryCode);

      setState(() {});
    });
  }

  @override
  void dispose() {
    authController.nameController.clear();
    authController.emailController.clear();
    authController.passController.clear();
    authController.phoneController.clear();
    super.dispose();
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
              appBar: const AppBarWidget3(text: ''),
              backgroundColor: AppColor.primaryBackgroundColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomText(
                          text: "Sign Up".tr,
                          color: AppColor.primaryColor,
                          weight: FontWeight.w700,
                          size: 26.sp,
                        ),
                        SizedBox(height: 12.h),
                        CustomText(
                          text: "Let's create your account".tr,
                          size: 16.sp,
                        ),
                        SizedBox(height: 30.h),
                        Form(
                          key: formkey,
                          child: Column(
                            children: [
                              FormFieldTitle(title: "Name".tr),
                              SizedBox(height: 4.h),
                              CustomFormField(
                                controller: authController.nameController,
                                validator: (name) =>
                                    ValidationRules().name(name),
                              ),
                              SizedBox(height: 20.h),
                              const SwapFieldTitle(),
                              SizedBox(height: 4.h),
                              SwapFormField(
                                emailController: authController.emailController,
                                emailValidator: (email) =>
                                    ValidationRules().email(email),
                                phoneController: authController.phoneController,
                                prefix: Text(
                                  box.read('callingCode') ?? "",
                                  style: GoogleFonts.urbanist(
                                    color: AppColor.textColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                phoneValidator: (phone) =>
                                    ValidationRules().phone(phone),
                              ),
                              SizedBox(height: 20.h),
                              FormFieldTitle(title: "Password".tr),
                              SizedBox(height: 4.h),
                              CustomFormField(
                                controller: authController.passController,
                                obsecure: true,
                                validator: (password) =>
                                    ValidationRules().password(password),
                              ),
                              SizedBox(height: 24.h),
                              PrimaryButton(
                                text: "Sign Up".tr,
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    swapController.isShowEmailField.value
                                        ? authController
                                              .registrationValidationWithEmail(
                                                name: authController
                                                    .nameController
                                                    .text,
                                                email: authController
                                                    .emailController
                                                    .text,
                                                password: authController
                                                    .passController
                                                    .text,
                                              )
                                        : authController
                                              .registrationValidationWithPhone(
                                                name: authController
                                                    .nameController
                                                    .text,
                                                phone: authController
                                                    .phoneController
                                                    .text,
                                                countryCode: box.read(
                                                  "callingCode",
                                                ),
                                                password: authController
                                                    .passController
                                                    .text,
                                              );
                                  } else {
                                    debugPrint("Something is wrong.");
                                  }
                                },
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "Already have an account?".tr,
                                    color: const Color(0xFF6E7191),
                                    size: 16.sp,
                                    weight: FontWeight.w500,
                                  ),
                                  SizedBox(width: 4.w),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const SignInScreen());
                                    },
                                    child: CustomText(
                                      text: "Sign In".tr,
                                      size: 16.sp,
                                      color: AppColor.primaryColor,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            authController.isLoading.value
                ? const LoaderCircle()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
