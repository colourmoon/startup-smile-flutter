import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebazaar/app/modules/auth/controller/otp_controller.dart';
import 'package:ebazaar/app/modules/auth/views/forget_otp_screen.dart';
import 'package:ebazaar/app/modules/auth/views/otp_screen.dart';
import 'package:ebazaar/app/modules/auth/views/reset_password.dart';
import 'package:ebazaar/app/modules/auth/views/sign_in.dart';
import 'package:ebazaar/app/modules/navbar/controller/navbar_controller.dart';
import 'package:ebazaar/app/modules/navbar/views/navbar_view.dart';
import 'package:ebazaar/config/theme/app_color.dart';
import 'package:ebazaar/data/model/country_code_model.dart';
import 'package:ebazaar/data/model/setting_model.dart';
import 'package:ebazaar/data/remote_services/remote_services.dart';
import 'package:ebazaar/main.dart';
import 'package:ebazaar/utils/api_list.dart';
import 'package:ebazaar/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/server/app_server.dart';

class AuthController extends GetxController {
  // final otpController = Get.put(OTPController());

  final isLoading = false.obs;

  CountryCodeModel? countryCodeModel;
  SettingModel? settingModel;
  RxList<CountryCodeModel> countryCodeMap = <CountryCodeModel>[].obs;
  RxList<SettingModel> settingMap = <SettingModel>[].obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();

  String countryCode = '';
  String emailVerification = '5';
  String phoneVerification = '5';
  String cashOnDelivery = '5';
  String onlinePayment = '5';
  String shippingMethod = '5';
  String currency = '\$';
  String companyCountryCode = "";

  AppServer server = AppServer();

  static Future<BaseOptions> getBasseOptionsWithToken() async {
    BaseOptions options = BaseOptions(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      headers: AppServer.getHttpHeadersWithToken(),
    );

    return options;
  }

  @override
  void onInit() {
    if (box.read('isLogedIn') == null) {
      box.write('isLogedIn', false);
    } else if (box.read('isLogedIn') == true) {
      getRefreshToken();
    }
    getCountryCode();
    getSetting();
    getCallingCode();
    super.onInit();
  }

  getSetting() async {
    settingModel = await RemoteServices.getSetting();

    settingMap.add(settingModel!);

    refresh();

    countryCode = settingModel!.data?.companyCallingCode.toString() ?? '';
    companyCountryCode =
        settingModel!.data?.companyCountryCode.toString() ?? "";
    emailVerification =
        settingModel!.data?.siteEmailVerification.toString() ?? '';
    phoneVerification =
        settingModel!.data?.sitePhoneVerification.toString() ?? '';
    cashOnDelivery = settingModel!.data?.siteCashOnDelivery.toString() ?? '';
    onlinePayment =
        settingModel!.data?.siteOnlinePaymentGateway.toString() ?? '';
    shippingMethod = settingModel!.data?.shippingSetupMethod.toString() ?? '';
    currency = settingModel!.data?.siteDefaultCurrencySymbol.toString() ?? '';
    refresh();
  }

  getCountryCode() async {
    countryCodeModel = await RemoteServices.getCountryCode();

    countryCodeMap.add(countryCodeModel!);

    refresh();
  }

  resetPasswordWithEmail({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.resetForgotPassword,
        body: {
          "email": email,
          "password": newPassword,
          "password_confirmation": confirmPassword,
        },
      );

    

      if (response.statusCode == 201) {
        isLoading(false);
        print(jsonDecode(response.body)["token"]);
        final token = jsonDecode(response.body)["token"];
        print(token);
        box.write("token", 'Bearer $token');
        box.write("isLogedIn", true);
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        Get.offAll(() => const NavBarView());
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["errors"]['message'][0].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  resetPasswordWithPhone({
    required String phone,
    required String countryCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.resetForgotPassword,
        body: {
          "phone": phone,
          'country_code': countryCode,
          "password": newPassword,
          "password_confirmation": confirmPassword,
        },
      );

      if (response.statusCode == 201) {
        isLoading(false);
        final token = jsonDecode(response.body)["token"];
        box.write("token", 'Bearer $token');
        box.write("isLogedIn", true);
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        Get.offAll(() => const NavBarView());
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["errors"]['message'][0].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  forgotPasswordWithEmail({required String email}) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.forgotPassword,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        isLoading(false);
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );
        if (emailVerification == '5') {
          Get.to(() => ForgetOTPScreen(emailOrPhone: email));
        } else if (emailVerification == '10') {
          Get.to(() => ResetPasswordScreen(emailOrPhone: email));
        }
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["errors"]['email'][0].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  forgotPasswordWithPhone({
    required String phone,
    required String country_code,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.forgotPassword,
        body: {"phone": phone, 'country_code': country_code},
      );

      if (response.statusCode == 200) {
        isLoading(false);
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );

        if (phoneVerification == '5') {
          Get.to(
            () =>
                ForgetOTPScreen(emailOrPhone: phone, countryCode: countryCode),
          );
        } else if (phoneVerification == '10') {
          Get.to(
            () => ResetPasswordScreen(
              emailOrPhone: phone,
              countryCode: country_code,
            ),
          );
        }
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["errors"]['phone'][0].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  Future<void> registrationValidationWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.registrationValidation.toString(),
        body: {"name": name, "email": email, "password": password},
      );

      print(
        "Sending registration validation body: "
        "${{"name": name, "email": email, "password": password}}",
      );
      print("response: ${response.body}");

      if (response.statusCode == 200) {
        isLoading(false);

        final resJson = jsonDecode(response.body);

        print('resJson >>>>>$resJson');

        if (emailVerification == '5') {
          OTPController otpController = Get.put(OTPController());

          otpController.sendOTPWithEmail(email: emailController.text);
          Get.to(() => OTPScreen(emailOrPhone: email));
        } else if (emailVerification == '10') {
          registrationWithEmail(
            name: nameController.text,
            email: email,
            password: passController.text,
          );
          Get.to(() => const SignInScreen());
        }
      } else {
        isLoading(false);
        final errorMsg =
            jsonDecode(response.body)["message"] ?? "Something went wrong";
        customSnackbar("ERROR".tr, errorMsg.toString().tr, AppColor.error);
      }
    } catch (e) {
      print("Error occurred: $e");
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }


/* registrationValidationWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.registrationValidation.toString(),
        body: {"name": name, "email": email, "password": password},
      );
      print("Sending registration validation body: ${{"name": name, "email": email, "password": password}}");
      print(
        "response: ${response.data}",
      );


      if (response.statusCode == 200) {
        isLoading(false);

        if (emailVerification == '5') {
          OTPController otpController = Get.put(OTPController());

          otpController.sendOTPWithEmail(email: emailController.text);
          Get.to(() => OTPScreen(emailOrPhone: email));
        } else if (emailVerification == '10') {
          registrationWithEmail(
            name: nameController.text,
            email: email,
            password: passController.text,
          );
          Get.to(() => const SignInScreen());
        }
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  } */
//newly added registrationValidationWithEmail with http post and
//  Future<void> registrationValidationWithEmail({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     isLoading(true);
//     try {
//       var headers = {
//         'x-api-key': '123123', // your API key
//       };

//       var request = http.MultipartRequest('POST', Uri.parse(ApiList.registrationValidation.toString()));

//       request.fields.addAll({
//         "name": name,
//         "email": email,
//         "password": password,
//       });

//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();
//       print('HELLOOOOOOOOO');
//       print(response.statusCode);
//       print(await response.stream.bytesToString());

//        if (response.statusCode == 200) {
//         isLoading(false);

//         if (emailVerification == '5') {
//           OTPController otpController = Get.put(OTPController());

//           otpController.sendOTPWithEmail(email: emailController.text);
//           Get.to(() => OTPScreen(emailOrPhone: email));
//         } else if (emailVerification == '10') {
//           registrationWithEmail(
//             name: nameController.text,
//             email: email,
//             password: passController.text,
//           );
//           Get.to(() => const SignInScreen());
//         }
//       } else {
//         isLoading(false);
//         final errorMsg = response.reasonPhrase ?? "Something went wrong";
//         customSnackbar("ERROR".tr, errorMsg, AppColor.error);
//       }
//     } catch (e) {
//       isLoading(false);
//       print(e);
//       customSnackbar("ERROR".tr, e.toString(), AppColor.error);
//     } finally {
//       isLoading(false);
//     }
//   }

  

  registrationWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.register,
        body: {"name": name, "email": email, "password": password},
      );

      if (response.statusCode == 200) {
        isLoading(false);

        nameController.clear();
        emailController.clear;
        passController.clear;
        phoneController.clear();
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }





  registrationValidationWithPhone({
    required String name,
    required String phone,
    required String countryCode,
    required String password,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.registrationValidation.toString(),
        body: {
          "name": name,
          "phone": phone,
          "country_code": countryCode,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        isLoading(false);
        if (phoneVerification == '5') {
          OTPController otpController = Get.put(OTPController());

          otpController.sendOTPWithPhone(
            phone: phoneController.text,
            country_code: countryCode,
          );
          Get.to(
            () => OTPScreen(emailOrPhone: phone, countryCode: countryCode),
          );
        } else if (phoneVerification == '10') {
          registrationWithPhone(
            name: nameController.text,
            phone: phoneController.text,
            countryCode: countryCode,
            password: passController.text,
          );
          Get.to(() => const SignInScreen());
        }
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  registrationWithPhone({
    required String name,
    required String phone,
    required String countryCode,
    required String password,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.register,
        body: {
          "name": name,
          "phone": phone,
          "country_code": countryCode,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        isLoading(false);
        nameController.clear();
        emailController.clear;
        passController.clear;
        phoneController.clear();
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  // Future<void> signInWithEmail({
  //   required String email,
  //   required String password,
  // }) async {
  //   isLoading(true);
  //   try {
  //     var headers = {
  //       'x-api-key': '123123', // your API key
  //     };

  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(ApiList.login),
  //     );

  //     request.fields.addAll({'email': email, 'password': password});

  //     request.headers.addAll(headers);

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 201) {
  //       final responseBody = await response.stream.bytesToString();
  //       final data = jsonDecode(responseBody);

  //       print('data >>>>>>>>>>>>$data');

  //       final token = data["token"];
  //       box.write('justToken', token);
  //       box.write("token", 'Bearer $token');
  //       box.write("isLogedIn", true);

  //       getSetting();

  //       customSnackbar(
  //         "SUCCESS".tr,
  //         data["message"].toString().tr,
  //         AppColor.success,
  //       );

  //       Future.delayed(const Duration(milliseconds: 10), () {
  //         update();
  //       });

  //       final navController = Get.put(NavbarController());
  //       Get.to(() => const NavBarView());
  //       navController.selectPage(0);
  //     } else {
  //       isLoading(false);
  //       final errorMsg = response.reasonPhrase ?? "Something went wrong";
  //       customSnackbar("ERROR".tr, errorMsg, AppColor.error);
  //     }
  //   } catch (e) {
  //     isLoading(false);
  //     print(e);
  //     customSnackbar("ERROR".tr, e.toString(), AppColor.error);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  signInWithEmail({required String email, required String password}) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.login,
        body: {"email": email, "password": password},
      );
      print({"email": email, "password": password});

      if (response.statusCode == 201) {
        isLoading(false);
        final token = jsonDecode(response.body)["token"];
        box.write('justToken', token);
        box.write("token", 'Bearer $token');
        box.write("isLogedIn", true);
        getSetting();
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        final navController = Get.put(NavbarController());
        Get.to(() => const NavBarView());
        navController.selectPage(0);
      } else {
        isLoading(false);

        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["errors"]['validation'].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      print(e);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  } 

//  Future<void> signInWithPhone({
//       required String phone,
//     required String countryCode,
//     required String password,
//   }) async {
//     isLoading(true);
//     try {
//       var headers = {
//         'x-api-key': '123123', // your API key
//       };

//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(ApiList.login),
//       );

//       request.fields.addAll({"phone": phone, "country_code": countryCode, 'password': password});

//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 201) {
//         final responseBody = await response.stream.bytesToString();
//         final data = jsonDecode(responseBody);

//         print('data >>>>>>>>>>>>$data');

//         final token = data["token"];
//         box.write('justToken', token);
//         box.write("token", 'Bearer $token');
//         box.write("isLogedIn", true);

//         getSetting();

//         customSnackbar(
//           "SUCCESS".tr,
//           data["message"].toString().tr,
//           AppColor.success,
//         );

//         Future.delayed(const Duration(milliseconds: 10), () {
//           update();
//         });

//         final navController = Get.put(NavbarController());
//         Get.to(() => const NavBarView());
//         navController.selectPage(0);
//       } else {
//         isLoading(false);
//         final errorMsg = response.reasonPhrase ?? "Something went wrong";
//         customSnackbar("ERROR".tr, errorMsg, AppColor.error);
//       }
//     } catch (e) {
//       isLoading(false);
//       print(e);
//       customSnackbar("ERROR".tr, e.toString(), AppColor.error);
//     } finally {
//       isLoading(false);
//     }
//   }

 signInWithPhone({
    required String phone,
    required String countryCode,
    required String password,
  }) async {
    isLoading(true);
    try {
      final response = await AppServer().httpPost(
        endPoint: ApiList.login,
        body: {
          "phone": phone,
          "country_code": countryCode,
          "password": password,
        },
      );

      if (response.statusCode == 201) {
        isLoading(false);
        final token = jsonDecode(response.body)["token"];
        box.write('justToken', token);
        box.write("token", 'Bearer $token');
        box.write("isLogedIn", true);
        getSetting();
        customSnackbar(
          "SUCCESS".tr,
          jsonDecode(response.body)["message"].toString().tr,
          AppColor.success,
        );
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        final navController = Get.put(NavbarController());
        Get.to(() => const NavBarView());
        navController.selectPage(0);
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          jsonDecode(response.body)["errors"]['validation'].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  logout() async {
    isLoading(true);
    var dio = Dio(await getBasseOptionsWithToken());
    String url = ApiList.logout.toString();
    try {
      final response = await dio.post(
        url,
        options: Options(headers: AppServer.getAuthHeaders()),
      );

      if (response.statusCode == 200) {
        isLoading(false);
        customSnackbar(
          "SUCCESS".tr,
          response.data["message"].toString().tr,
          AppColor.success,
        );
        box.write('isLogedIn', false);
        getSetting();
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        final navController = Get.put(NavbarController());
        Get.offAll(() => const NavBarView());
        navController.selectPage(0);
      } else {
        isLoading(false);
        customSnackbar(
          "ERROR".tr,
          response.data["message"].toString().tr,
          AppColor.error,
        );
      }
    } catch (e) {
      isLoading(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.error);
    }
  }

  Future getRefreshToken() async {
    try {
      server
          .getRequestWithoutToken(
            endPoint: ApiList.refreshToken! + box.read('justToken'),
          )
          .then((response) {
            if (response != null && response.statusCode == 201) {
              final jsonResponse = json.decode(response.body);
              var bearerToken = 'Bearer ${jsonResponse["token"]}';
              box.write('token', bearerToken);
              update();
            } else {
              box.write('isLogedIn', false);
              box.remove('token');
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getCallingCode() async {
    final response = await server.getRequest(
      endPoint: ApiList.getCallingCode(countryCode: companyCountryCode),
      headers: AppServer.getAuthHeaders(),
    );

    print('companyCountryCode >>>>$companyCountryCode');
    print('response.statusCode >>>>${response.statusCode}');
    print('response.data >>>>${response.data}');

    // print('111111111 >>>>${response.data['data']}');
    // print('response.data222 >>>>${response.data['data']['calling_code']}');



    if (response.statusCode == 200) {
      //await box.write('callingCode', response.data['data']['calling_code']);
      await box.write('callingCode', '+91');

      update();
    }
  }

  Future postDeviceToken(token) async {
    isLoading(true);
    update();
    Map body = {'token': token};
    String jsonBody = json.encode(body);
    try {
      server.postRequestWithToken(endPoint: ApiList.token, body: jsonBody).then(
        (response) {
          if (response != null && response.statusCode == 200) {
            isLoading(false);
            update();
          } else {
            isLoading(false);
            update();
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      isLoading(false);
      update();
    }
    isLoading(false);
    update();
  }
}
