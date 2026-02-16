import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:sph_mobile/app/routes/app_pages.dart';
import 'package:sph_mobile/app/routes/app_routes.dart';

void main() {
  setUpAll(() async {
    // Mock path_provider
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return '/tmp';
        }
        return null;
      },
    );
    
    // Initialize GetStorage for tests
    await GetStorage.init();
  });

  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.LOGIN,
      getPages: AppPages.pages,
    ));

    // Verify that the app loads without crashing
    await tester.pumpAndSettle();
    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
