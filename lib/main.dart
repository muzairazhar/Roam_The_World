import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restart_app/restart_app.dart';
import 'package:roam_the_world_app/pages/Utills/App-Constant.dart';
import 'package:roam_the_world_app/widgets/restart_widget.dart';
import 'firebase_options.dart';
import 'package:roam_the_world_app/routes/app_pages.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:roam_the_world_app/utils/screens_bindings.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=AppConstant.publishKey;
  await Stripe.instance.applySettings();
print("lura hoagay");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(RestartWidget(child: const RoamTheWorldApp()));
}

class RoamTheWorldApp extends StatelessWidget {
  const RoamTheWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return GetMaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'Roam the World',
          themeMode: ThemeMode.light,
          theme: ThemeData(
            primarySwatch: AppColors.primarySwatch,
            textTheme: GoogleFonts.poppinsTextTheme(),
            brightness: Brightness.light,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            primaryColor: AppColors.primaryColor,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primaryColor,
              selectionColor: AppColors.primaryColor.withOpacity(0.5),
              selectionHandleColor: AppColors.primaryColor,
            ),
          ),
          initialRoute: AppRoutes.kSplashScreenRoute,
          initialBinding: ScreensBindings(),
          getPages: RouteManagement.getPages(),
        );
      },
    );
  }
}
