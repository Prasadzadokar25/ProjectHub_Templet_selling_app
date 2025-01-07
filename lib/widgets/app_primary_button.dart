import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/constant/app_color.dart';

class AppPrimaryButton extends StatelessWidget {
  dynamic onPressed;
  String title;
  Widget? icon;
  double? height;
  Color? backgroundImage;
  AppPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.height,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: onPressed,
        child: Container(
          height: (height != null) ? height : Get.height * 0.06,
          decoration: BoxDecoration(
            color: (backgroundImage != null)
                ? backgroundImage
                : AppColor.primaryColor,
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

class AppPrimaryElevetedButton extends StatefulWidget {
  dynamic onPressed;
  String title;
  Icon? icon;
  AppPrimaryElevetedButton(
      {super.key, required this.onPressed, required this.title, this.icon});

  @override
  State<AppPrimaryElevetedButton> createState() =>
      _AppPrimaryElevetedButtonState();
}

class _AppPrimaryElevetedButtonState extends State<AppPrimaryElevetedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: widget.icon,
        label: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColor.iconPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
    ;
  }
}
