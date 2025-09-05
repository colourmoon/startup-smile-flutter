// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio_postfix;
import 'package:ebazaar/app/modules/cart/model/product_model.dart';
import 'package:ebazaar/app/modules/category/controller/category_wise_product_controller.dart';
import 'package:ebazaar/app/modules/category/model/category_tree.dart';
import 'package:ebazaar/app/modules/category/model/category_wise_product.dart';
import 'package:ebazaar/app/modules/coupon/model/apply_coupon.dart';
import 'package:ebazaar/app/modules/home/model/brand_model.dart';
import 'package:ebazaar/app/modules/home/model/category_model.dart';
import 'package:ebazaar/app/modules/home/model/product_section.dart';
import 'package:ebazaar/app/modules/home/model/promotion_model.dart';
import 'package:ebazaar/app/modules/language/model/language_model.dart';
import 'package:ebazaar/app/modules/payment/model/paymet_method.dart';
import 'package:ebazaar/app/modules/product_details/model/children_variation.dart';
import 'package:ebazaar/app/modules/product_details/model/initial_variation.dart';
import 'package:ebazaar/app/modules/product_details/model/related_product.dart';
import 'package:ebazaar/app/modules/search/model/all_product.dart';
import 'package:ebazaar/app/modules/shipping/model/coupon.dart';
import 'package:ebazaar/app/modules/shipping/model/outlet_model.dart';
import 'package:ebazaar/app/modules/shipping/model/show_address.dart';
import 'package:ebazaar/data/model/country_code_model.dart';
import 'package:ebazaar/data/model/setting_model.dart';
import 'package:ebazaar/data/server/app_server.dart';
import 'package:ebazaar/utils/api_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/modules/home/model/slider_model.dart';
import '../../app/modules/promotion/model/promotion_wise_product.dart';
import '../../main.dart';

class RemoteServices {
  static Future<dio_postfix.BaseOptions> getBasseOptions() async {
    dio_postfix.BaseOptions options = dio_postfix.BaseOptions(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      headers: AppServer.getAuthHeaders(),
    );

    return options;
  }

  static Future<dio_postfix.BaseOptions> getBasseOptionsWithToken() async {
    dio_postfix.BaseOptions options = dio_postfix.BaseOptions(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      headers: AppServer.getHttpHeadersWithToken(),
    );

    return options;
  }

  AppServer server = AppServer();

  static Future<SettingModel> getSetting() async {
    var response;
    var dio = dio_postfix.Dio(await getBasseOptions());
    String url = ApiList.setting.toString();
    try {
      response = await dio.get(url);
      if (response.statusCode == 200) {
        return SettingModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return SettingModel.fromJson(response.data);
  }

  static Future<CountryCodeModel> getCountryCode() async {
    var response;
    var dio = dio_postfix.Dio(await getBasseOptions());
    String url = ApiList.countryCode.toString();
    try {
      response = await dio.get(url);
      if (response.statusCode == 200) {
        return CountryCodeModel.fromJson(response.data);
      }
    } catch (e) {}
    return CountryCodeModel.fromJson(response.data);
  }

  Future<Either<String, SliderModel>> fetchSlider() async {
    final response = await server.getRequest(
      endPoint: ApiList.slider,
      headers: AppServer.getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(SliderModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, CategoryModel>> fetchCategory() async {
    final response = await server.getRequest(
      endPoint: ApiList.productCategory,
      headers: AppServer.getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      print('fetchCategory data in service: $data');
      return Right(CategoryModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, List<CategoryTreeModel>>> fetchCategoryTree() async {
    final response = await server.getRequest(
      endPoint: ApiList.categoryTree,
      headers: AppServer.getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      return Right(data.map((e) => CategoryTreeModel.fromJson(e)).toList());
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, ProductSectionModel>> fetchProductSection() async {
    final response = await server.getRequest(
      endPoint: '${ApiList.productSection}?order_type=asc&status=5',
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(ProductSectionModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, PromotionModel>> fetchPromotion() async {
    final response = await server.getRequest(
      endPoint: ApiList.promotion,
      headers: AppServer.getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(PromotionModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, PromotionWiseProductModel>> fetchPromotionWiseProduct({
    required String promotionSlug,
    required int paginate,
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await AppServer().getRequestNoToken(
        endPoint: ApiList.promotionWiseProduct(
          slug: promotionSlug,
          page: page,
          paginate: paginate,
          perPage: perPage,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(PromotionWiseProductModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, PromotionModel>> fetchMultiPromotion() async {
    final response = await server.getRequest(
      endPoint: ApiList.multiPromotion,
      headers: AppServer.getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(PromotionModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  final categoryWiseProductController = Get.put(
    CategoryWiseProductController(),
  );
  Future<Either<String, CategoryWiseProduct>> fetchCategoryWiseProduct({
    final category,
    String? brands,
    status,
    String? sortBy,
    minPrice,
    maxPrice,
    String? name,
    variations,
    int? page,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.categoryWiseProduct,
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
      body: {
        "category": category,
        "brand": brands,
        "status": 5,
        "sort_by": sortBy ?? "",
        "min_price": minPrice,
        "max_price": maxPrice,
        "name": name,
        "variation": variations,
        "page": page,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      categoryWiseProductController.variationsMap = data["data"]["variations"];
      return Right(CategoryWiseProduct.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, ProductModel>> fetchProductDetails({
    required String slug,
    required int reviewLimit,
  }) async {
    final response = await server.getRequest(
      endPoint:
          '${ApiList.productDetails}$slug?slug=$slug&review_limit=$reviewLimit',
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(ProductModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, RelatedProductModel>> fetchRelatedProducts({
    required String slug,
  }) async {
    final response = await server.getRequest(
      endPoint: ApiList.relatedProducts + slug,
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(RelatedProductModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, InitialVariationModel>> fetchInitialVariation({
    required String productId,
  }) async {
    final response = await server.getRequest(
      endPoint: ApiList.initialVariation + productId,
      headers: AppServer.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(InitialVariationModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, ChildrenVariationModel>> fetchChildrenVariation({
    required String initialVariationId,
  }) async {
    final response = await server.getRequest(
      endPoint: ApiList.childrenVariation + initialVariationId,
      headers: AppServer.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(ChildrenVariationModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  submitAddress({
    required String fullName,
    String? email,
    required String countryCode,
    required String phone,
    required String streetAddress,
    required String country,
    String? state,
    String? city,
    String? zip,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.address,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "full_name": fullName,
        "email": email,
        "country_code": countryCode,
        "phone": phone,
        "country": country,
        "address": streetAddress,
        "state": state,
        "city": city,
        "zip_code": zip,
        "latitude": "",
        "longitude": "",
      },
    );

    return response;
  }

  Future<Either<String, ShowAddressModel>> fetchAddress() async {
    final response = await server.getRequest(
      endPoint: ApiList.showAddress,
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(ShowAddressModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, OutletModel>> fetchOutlets() async {
    final response = await server.getRequest(
      endPoint: ApiList.outlet,
      headers: AppServer.getHttpHeadersWithToken(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(OutletModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, LanguageModel>> fetchLanguage() async {
    final response = await server.postRequest(endPoint: ApiList.language);
    if (response.statusCode == 200) {
      final data = response.data;

      return Right(LanguageModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, CouponModel>> fetchCoupon() async {
    final response = await server.getRequest(
      endPoint: ApiList.coupon,
      headers: AppServer.getHttpHeadersWithToken(),
    );
    if (response.statusCode == 200) {
      final data = response.data;

      return Right(CouponModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, ApplyCoupon>> submitCoupon({
    required String code,
    required String total,
  }) async {
    final response = await server.httpPost(
      endPoint: ApiList.applyCoupon,
      body: {"code": code, "total": total},
    );

    if (response.statusCode == 200) {
      box.write("applyCoupon", true);
      final data = jsonDecode(response.body);
      return Right(ApplyCoupon.fromJson(data));
    } else {
      box.write("applyCoupon", false);
      return Left(jsonDecode(response.body)["message"]);
    }
  }

  Future<Either<String, AllProducts>> fetchAllProduct() async {
    final response = await server.getRequest(
      endPoint: ApiList.allProducts,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(AllProducts.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, CategoryWiseProduct>> searchProduct({
    required String name,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.categoryWiseProduct,
      body: {'name': name, 'brand': []},
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(CategoryWiseProduct.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, BrandModel>> fetchBrands() async {
    final response = await server.getRequest(
      endPoint: "${ApiList.brands}?&order_type=asc&status=5",
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(BrandModel.fromJson(data));
    } else {
      return const Left("Something went wrong.");
    }
  }

  Future<Either<String, ProductModel>> fetchCartProduct(String slug) async {
    final response = await server.getRequest(
      endPoint: "${ApiList.showCartProduct}/$slug",
      headers:
          box.read('isLogedIn') == false
              ? AppServer.getAuthHeaders()
              : AppServer.getHttpHeadersWithToken(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(ProductModel.fromJson(data));
    } else {
      return const Left("Something went wrong");
    }
  }

  Future<Either<String, PaymentMethodModel>> fetchPaymentMethods() async {
    final response = await server.getRequest(
      endPoint: ApiList.paymentGateway,
      headers: AppServer.getHttpHeadersWithToken(),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return Right(PaymentMethodModel.fromJson(data));
    } else {
      return const Left("Something went wrong");
    }
  }
}
