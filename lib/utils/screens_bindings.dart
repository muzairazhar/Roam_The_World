import 'package:get/get.dart';
import 'package:roam_the_world_app/pages/auth/forget_password/controller/reset_password_controller.dart';
import 'package:roam_the_world_app/pages/auth/sign_in/controller/sign_in_controller.dart';
import 'package:roam_the_world_app/pages/auth/sign_up/controller/sign_up_controller.dart';
import 'package:roam_the_world_app/pages/general_setting/controller/generatl_setting_controller.dart';
import 'package:roam_the_world_app/pages/main/controller/main_controller.dart';
import 'package:roam_the_world_app/pages/onbording/controller/onboarding_controller.dart';
import 'package:roam_the_world_app/pages/complete_profile/controller/complete_profile_controller.dart';
import 'package:roam_the_world_app/pages/profile/controller/change_password_controller.dart';
import 'package:roam_the_world_app/pages/profile/controller/profile_setting_controller.dart';

class ScreensBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => CompleteProfileController());
    Get.lazyPut(() => ResetPasswordController());
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => ProfileSettingController());
    Get.lazyPut(() => ChangePasswordController());
    Get.lazyPut(() => GeneratlSettingController());
    // Get.lazyPut(() => HomeController());
  }
}
