import 'package:get/get.dart';
import 'package:roam_the_world_app/pages/airline/airline_detail_screen.dart';
import 'package:roam_the_world_app/pages/auth/forget_password/forget_password_screen.dart';
import 'package:roam_the_world_app/pages/auth/forget_password/forget_password_verify_otp_screen.dart';
import 'package:roam_the_world_app/pages/auth/sign_in/sign_in_screen.dart';
import 'package:roam_the_world_app/pages/auth/sign_up/email_verification_screen.dart';
import 'package:roam_the_world_app/pages/auth/sign_up/sign_up_screen.dart';
import 'package:roam_the_world_app/pages/auth/signin_or_signup_screen.dart';
import 'package:roam_the_world_app/pages/chat/chat_room_screen.dart';
import 'package:roam_the_world_app/pages/complete_profile/complete_profile_screen.dart';
import 'package:roam_the_world_app/pages/extras/help_center_screen.dart';
import 'package:roam_the_world_app/pages/extras/privacy_policy_screen.dart';
import 'package:roam_the_world_app/pages/extras/terms_and_conditions_screen.dart';
import 'package:roam_the_world_app/pages/general_setting/general_setting_screen.dart';
import 'package:roam_the_world_app/pages/main/main_screen.dart';
import 'package:roam_the_world_app/pages/onbording/onboarding_screen.dart';
import 'package:roam_the_world_app/pages/post/add_post_screen.dart';
import 'package:roam_the_world_app/pages/post/country_base_posts_screen.dart';
import 'package:roam_the_world_app/pages/post/post_detail_screen.dart';
import 'package:roam_the_world_app/pages/profile/change_password_screen.dart';
import 'package:roam_the_world_app/pages/profile/profile_setting_screen.dart';
import 'package:roam_the_world_app/pages/setting/setting_screen.dart';
import 'package:roam_the_world_app/pages/splash/splash_screen.dart';
import 'package:roam_the_world_app/pages/subscription/subscription_screen.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/screens_bindings.dart';

import '../pages/auth/forget_password/reset_password_screen.dart';

class RouteManagement {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: AppRoutes.kSplashScreenRoute,
        page: () => const SplashScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kOnboardScreenRoute,
        page: () => const OnboardingScreen(),
        binding: ScreensBindings(),
      ),
      // Auth
      GetPage(
        name: AppRoutes.kSignInOrSignUpRoute,
        page: () => const SignInOrSignUpScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kSignInScreenRoute,
        page: () => const SignInScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kSignUpScreenRoute,
        page: () => const SignUpScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kEmailVerificationScreenRoute,
        page: () => const EmailVerificationScreen(),
        binding: ScreensBindings(),
      ),
      // COMPLETE PROFILE ROUTE
      GetPage(
        name: AppRoutes.kCompleteProfileScreenRoute,
        page: () => const CompleteProfileScreen(),
        binding: ScreensBindings(),
      ),
      // FORGOT PASSWORD ROUTES
      GetPage(
        name: AppRoutes.kForgetPasswordScreenRoute,
        page: () => const ForgetPasswordScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kForgetPasswordVerifyOtpScreenRoute,
        page: () => const ForgetPasswordVerifyOtpScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kResetPasswordScreenRoute,
        page: () => const ResetPasswordScreen(),
        binding: ScreensBindings(),
      ),
      // MAIN ROUTES
      GetPage(
        name: AppRoutes.kMainScreenRoute,
        page: () => const MainScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kChatRoomScreenRoute,
        page: () => const ChatRoomScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kAirlineDetailScreenRoute,
        page: () => const AirlineDetailScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kSettingScreenRoute,
        page: () => const SettingScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kSubscriptionScreenRoute,
        page: () => const SubscriptionScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kProfileSettingScreenRoute,
        page: () => const ProfileSettingScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kGeneralSettingScreenRoute,
        page: () => const GeneralSettingScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kChangePasswordScreenRoute,
        page: () => const ChangePasswordScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kHelpCentreScreenRoute,
        page: () => const HelpCenterScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kPrivacyPolicyScreenRoute,
        page: () => const PrivacyPolicyScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kTermsAndConditionsScreenRoute,
        page: () => const TermsAndConditionsScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kAddPostScreenScreenRoute,
        page: () => const AddPostScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kCountryBasePostsScreenRoute,
        page: () => const CountryBasePostsScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: AppRoutes.kPostDetailScreenRoute,
        page: () => const PostDetailScreen(),
        binding: ScreensBindings(),
      ),

      // GetPage(
      //   name: kHomeScreenRoute,
      //   page: () {
      //     Get.find<BottomNavigationController>().selectedIndex(0);
      //     return const HomeScreen();
      //   },
      //   binding: ScreensBindings(),
      // ),
      // GetPage(
      //   name: kUserListingScreenRoute,
      //   page: () {
      //     Get.find<BottomNavigationController>().selectedIndex(2);
      //     return const UserListingScreen();
      //   },
      //   binding: ScreensBindings(),
      // ),
      // GetPage(
      //   name: kBusinessDetailScreenRoute,
      //   page: () {
      //     BusinessModel business = Get.arguments as BusinessModel;
      //     Get.find<BottomNavigationController>().selectedIndex(0);
      //     return BusinessDetailScreen(business: business);
      //   },
      //   binding: ScreensBindings(),
      // ),
    ];
  }
}