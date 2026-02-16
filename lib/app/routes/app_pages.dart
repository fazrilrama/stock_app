import 'package:get/get.dart';
import 'package:sph_mobile/app/modules/main/main_view.dart';
import 'package:sph_mobile/app/modules/profile/profile_view.dart';
import '../middleware/auth_middleware.dart';
import '../modules/login/login_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/main/main_binding.dart';
import '../modules/notification/notification_view.dart';
import '../modules/notification/notification_binding.dart';
import '../modules/stock_opname/stock_opname_view.dart';
import '../modules/stock_opname/stock_opname_binding.dart';
import '../modules/create_opname/create_opname_view.dart';
import '../modules/create_opname/create_opname_binding.dart';
import '../modules/approval/approval_view.dart';
import '../modules/approval/approval_binding.dart';
import '../modules/opname_detail/opname_detail_view.dart';
import '../modules/opname_detail/opname_detail_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.Profile, 
      page: () => ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.Main, 
      page: () => MainView(),
      binding: MainBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.STOCK_OPNAME,
      page: () => StockOpnameView(),
      binding: StockOpnameBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.CREATE_OPNAME,
      page: () => CreateOpnameView(),
      binding: CreateOpnameBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.APPROVAL,
      page: () => ApprovalView(),
      binding: ApprovalBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '${Routes.OPNAME_DETAIL}/:id',
      page: () => OpnameDetailView(),
      binding: OpnameDetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
