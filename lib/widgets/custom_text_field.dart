import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final bool isDesription;

  final bool? readOnly;
  Widget? suffixCustomIcon;
  final IconData? suffixIcon;
  final double height;
  final double radius;
  final Color? borderColor;
  final Color? iconsColor;
  final Color? backgroundColor;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? labelText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final double? width;
  final VoidCallback? suffixPressed;

  CustomTextField({
    super.key,
    this.prefixIcon,
    this.onTap,
    this.isDesription = false,
    this.height = 12,
    this.radius = 3,
    this.readOnly,
    this.suffixCustomIcon,
    this.suffixIcon,
    this.borderColor,
    this.iconsColor,
    this.backgroundColor,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.validator,
    this.hintText,
    this.labelText,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.width,
    this.suffixPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize(double fontSize) {
      return fontSize * size.width / 430;
    }

    suffixCustomIcon ??= Icon(
      suffixIcon,
      color: iconsColor,
      size: fontSize(20),
    );

    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? AppColors.kBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
    final focusBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.primaryColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
    return TextFormField(
      focusNode: focusNode,
      maxLines: isDesription ? 5 : 1,
      onTap: onTap ?? () {},
      readOnly: readOnly ?? false,
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        height: 2,
        fontSize: fontSize(14.sp),
        color: AppColors.kTextColor,
        // fontFamily: "Montserrat",
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: height),
        filled: true,
        fillColor: backgroundColor ?? AppColors.kBackgroundColor,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 15,
                ),
                child: Icon(
                  prefixIcon,
                  color: iconsColor ?? AppColors.kTextColor.withOpacity(0.7),
                  size: 24,
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? InkWell(
                onTap: suffixPressed,
                child: suffixCustomIcon,
              )
            : null,
        hintText: labelText == null ? hintText : null,
        hintStyle: GoogleFonts.poppins(
          color: AppColors.kTextColor.withOpacity(0.7),
          // fontSize: 14.sp,
          fontSize: fontSize(14.sp),
          // fontWeight: FontWeight.w400,
        ),
        // labelText: labelText,
        // labelStyle: GoogleFonts.poppins(
        //     fontSize: fontSize(20), color: AppColors.primaryColor),
        errorStyle: GoogleFonts.poppins(
          fontSize: fontSize(14.sp),
          color: const Color(0xffFF0000),
          // fontFamily: "Montserrat",
        ),
        focusColor: AppColors.primaryColor,
        enabledBorder: inputBorder,
        focusedBorder: focusBorder,
        focusedErrorBorder: inputBorder,
        errorBorder: inputBorder,
        border: inputBorder,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 30,
        ),
      ),
    );
  }
}
