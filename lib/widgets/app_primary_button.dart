import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/constant/app_color.dart';

class AppPrimaryButton extends StatelessWidget {
  dynamic onTap;
  String title;
  Widget? icon;
  AppPrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: onTap,
        child: Container(
          height: Get.height * 0.06,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              SizedBox(
                width: Get.width * 0.018,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
