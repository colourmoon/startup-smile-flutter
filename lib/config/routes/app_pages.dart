import 'package:get/get.dart';
import 'package:ebazaar/app/modules/category/bindings/category_bindings.dart';

import 'package:ebazaar/app/modules/home/bindings/home_bindings.dart';
import 'package:ebazaar/app/modules/home/views/home_screen.dart';
import 'package:ebazaar/app/modules/language/views/language_change_screen.dart';
import 'package:ebazaar/app/modules/navbar/bindings/navbar_binding.dart';
import 'package:ebazaar/app/modules/navbar/views/navbar_view.dart';
import 'package:ebazaar/app/modules/splash/binding/splash_binding.dart';
import 'package:ebazaar/config/routes/app_routes.dart';
import '../../app/modules/language/bindings/language_binding.dart';
import '../../app/modules/splash/views/splash_screen.dart';

class AppPages {
  AppPages._();

  static String initial = "/splash/";

  static final pages = [
    GetPage(
      name: initial,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.navBarView,
      page: () => const NavBarView(),
      bindings: [
        HomeBindings(),
        NavbarBinding(),
        CategoryTreeBindings(),
      ],
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: Routes.language,
      page: () => const ChangeLanguageView(),
      binding: LanguageBindings(),
    )
  ];
}
