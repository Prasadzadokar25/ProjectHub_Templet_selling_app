import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/app_padding.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListView(
          //controller: _scrollController,
          children: [
            SizedBox(height: Get.height * 0.012),
            getTopBarShimmer(),
            SizedBox(height: Get.height * 0.006),
            AdverticmentSlider(),
            SizedBox(height: Get.height * 0.018),
            getSectionHeddingShimmer(100.w),
            getCategoriesSliderShimmer(),
            SizedBox(height: Get.height * 0.018),
            getSectionHeddingShimmer(150.w),
            SizedBox(height: Get.height * 0.008),
            trendingCreationViewShimmer(),
            SizedBox(height: Get.height * 0.012),
            getSectionHeddingShimmer(150.w),
            SizedBox(height: Get.height * 0.008),
            getRecentlyAddedCreationViewShimmer(),
            SizedBox(height: Get.height * 0.012),

            SizedBox(height: Get.height * 0.012),
            // getOtherCreationView(),
            SizedBox(height: Get.height * 0.012),
          ],
        ),
      )),
    );
  }

  Widget getTopBarShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Container(
              color: Colors.white,
              height: 50.h,
              width: 50.h,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: Get.width * 0.6,
            height: 21.h,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget getSectionHeddingShimmer(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: width,
              height: 18.h,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoriesSliderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: Get.height * 0.135,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(AppPadding.edgePadding),
          itemBuilder: (context, index) => Container(
            width: Get.height * 0.135 - 2 * AppPadding.edgePadding,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemCount: 5,
        ),
      ),
    );
  }

  Widget trendingCreationViewShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 220.h,
        width: double.infinity.w,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: AppPadding.edgePadding, vertical: 4),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
            width: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.h),
              color: Colors.white,
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 10.w),
          itemCount: 3,
        ),
      ),
    );
  }

  Widget getRecentlyAddedCreationViewShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 320.h,
        width: double.infinity.w,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: AppPadding.edgePadding, vertical: 4),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
            width: 266.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.h),
              color: Colors.white,
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemCount: 3,
        ),
      ),
    );
  }
}

class AdverticmentSlider extends StatefulWidget {
  const AdverticmentSlider({super.key});

  @override
  State<AdverticmentSlider> createState() => _AdverticmentSliderState();
}

class _AdverticmentSliderState extends State<AdverticmentSlider> {
  List item = [
    1,
    2,
    3,
  ];
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
          height: Get.height * 0.21,
          //autoPlay: true,
          autoPlayAnimationDuration: const Duration(seconds: 1),
          autoPlayInterval: const Duration(seconds: 4),
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {});
          },
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          pageSnapping: true, // Snapping effect enabled
        ),
        items: item.map((item) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              margin: const EdgeInsets.all(7),
              height: Get.height * 0.21,
            ),
          );
        }).toList());
  }
}
