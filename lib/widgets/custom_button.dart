import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? textColor;
  final Widget? sufficIcon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? buttonColor;
  final BoxBorder? border;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? radius;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.textColor,
      this.sufficIcon,
      this.width,
      this.height,
      this.padding,
      this.buttonColor,
      this.border,
      this.fontSize,
      this.fontWeight,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50.h,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(radius ?? 10.r),
          border: border,
        ),
        child: Stack(
          children: [
            sufficIcon != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: sufficIcon,
                  )
                : Container(),
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: fontSize ?? 15.sp,
                  color: textColor ?? AppColors.kWhiteColor,
                  fontWeight: fontWeight ?? FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
