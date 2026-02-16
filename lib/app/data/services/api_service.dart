import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'auth_service.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8020/api/v1',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(

        /// 🔐 REQUEST → Inject Token
        onRequest: (options, handler) {
          final token = Get.find<AuthService>().token;

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        /// 🔄 RESPONSE → Auto Save New Token
        onResponse: (response, handler) {
          final newToken = response.headers.value('x-new-token');

          if (newToken != null && newToken.isNotEmpty) {
            Get.find<AuthService>().saveToken(newToken);
            print('🔄 Token diperbarui');
          }

          return handler.next(response);
        },

        /// 🚪 ERROR → Auto Logout
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            Get.find<AuthService>().logout();
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// 🔓 LOGIN (tanpa interceptor token)
  Future<Response> login(String email, String password) {
    return _dio.post(
      '/auth/login',
      data: {
        'username': email,
        'password': password,
      },
    );
  }

  /// 🔐 Contoh API protected
  Future<Response> getProfile() {
    return _dio.get('/profile');
  }

  /// 📢 Get Notifications
  Future<Response> getNotifications() {
    return _dio.get('/notif');
  }

  Future<Response> getRecently() {
    return _dio.get('/opname/recently');
  }

  Future<Response> getStockOpname({
    String? startDate,
    String? endDate,
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  }) {
    return _dio.get('/opname', queryParameters: {
      'start_date': startDate ?? '',
      'end_date': endDate ?? '',
      'search': search ?? '',
      'status': status ?? '',
      'page': page,
      'limit': limit,
    });
  }

  Future<Response> getApprovalRequests({
    String? startDate,
    String? endDate,
  }) {
    return _dio.get('/opname/request', queryParameters: {
      'start_date': startDate ?? '',
      'end_date': endDate ?? '',
    });
  }

  Future<Response> getOpnameDetail(String id) {
    return _dio.get('/opname', queryParameters: {
      'id': id,
    });
  }
}
