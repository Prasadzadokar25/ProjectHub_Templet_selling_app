import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:share_plus/share_plus.dart';

class CreatationCard extends StatefulWidget {
  final CreationInfoModel creation;
  const CreatationCard({super.key, required this.creation});

  @override
  State createState() => _CreatationCardState();
}

class _CreatationCardState extends State<CreatationCard> {
  Future<void> share() async {
    await Share.share('check out my website https://example.com');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: const Color(0XFF23408F).withOpacity(0.24),
              offset: const Offset(-4, 5),
              blurRadius: 16.h,
            ),
          ],
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.h),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0XFF23408F).withOpacity(0.14),
                        offset: const Offset(-4, 5),
                        blurRadius: 16.h),
                  ],
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 210.h,
                      width: double.infinity.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          color: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.h),
                            topRight: Radius.circular(12.h)),
                        child: Image(
                          image: AssetImage(widget.creation.imagePath),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: Container(
                          alignment: Alignment.center,
                          height: 33.h,
                          width: 32.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                              splashRadius: 10.h,
                              onPressed: () {},
                              icon: const Center(
                                child: Icon(
                                  Icons.save_as,
                                  size: 14,
                                ),
                              ))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 55.w, top: 10.h),
                      child: Container(
                        alignment: Alignment.center,
                        height: 33.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              share();
                            },
                            icon: const Icon(
                              Icons.share,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 10.42.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 27.h,
                      width: 59.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.h),
                        color: const Color(0XFFFAF4E1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_rate_rounded,
                            color: Color.fromARGB(255, 255, 196, 0),
                            size: 15,
                          ),
                          Text(
                            widget.creation.rating.toString(),
                            style: TextStyle(
                                color: const Color.fromARGB(255, 255, 196, 0),
                                fontFamily: 'Gilroy',
                                fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 11.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 68.w),
                  child: Text(
                    widget.creation.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        fontFamily: 'Gilroy',
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                SizedBox(height: 11.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          child: Image(
                            image: AssetImage(widget.creation.sellerImage!),
                            height: 40.h,
                            width: 40.w,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          widget.creation.sellerName,
                          style: TextStyle(
                              color: const Color(0XFF23408F),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Gilroy'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          width: 74.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.h),
                              color: const Color(0XFFE5ECFF)),
                          child: Center(
                              child: Text(
                            widget.creation.price.toString(),
                            style: TextStyle(
                                color: const Color(0XFF23408F),
                                fontFamily: 'Gilroy',
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w700),
                          )),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
