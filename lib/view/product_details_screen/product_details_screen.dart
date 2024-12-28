import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/model/creation_info_model.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatefulWidget {
  CreationInfoModel creation;
  ProductDetailsScreen({super.key, required this.creation});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool showReview = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.83,
            child: ListView(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: Get.height * 0.4,
                      width: Get.width,
                      child: Image.asset(
                        widget.creation.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ))),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_outline,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.black,
                              size: 22,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(AppPadding.edgePadding * 1.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.creation.title,
                        style: AppText.bigHeddingStyle1a,
                      ),
                      Text(
                        widget.creation.subtitle,
                        style: AppText.subHeddingStyle,
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Row(
                        children: [
                          Container(
                            height: Get.height * 0.045,
                            width: Get.height * 0.045,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(201, 190, 190, 190),
                              shape: BoxShape.circle,
                            ),
                            child: (widget.creation.sellerImage != null)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                        widget.creation.sellerImage!),
                                  )
                                : const Icon(Icons.person),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            widget.creation.sellerName,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColor.primaryColor,
                                fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(height: Get.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showReview = !showReview;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColor.secYello,
                              size: 20,
                            ),
                            SizedBox(width: Get.height * 0.01),
                            Text(
                              widget.creation.rating.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: Get.height * 0.01),
                            const Text(
                              "(3 Reviews)",
                              style: TextStyle(fontSize: 12),
                            ),
                            (showReview)
                                ? const Icon(Icons.arrow_drop_up)
                                : const Icon(Icons.arrow_drop_down_sharp)
                          ],
                        ),
                      ),
                      if (showReview) getReviews()
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
                  child: const Text(
                    "You may also like",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                suggestCreationView()
              ],
            ),
          ),
          getBottomContainer(),
        ],
      ),
    );
  }

  Widget getReviews() {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          padding: EdgeInsets.all(AppPadding.itermInsidePadding),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          //height: 100,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: Get.height * 0.04,
                    width: Get.height * 0.04,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(201, 190, 190, 190),
                      shape: BoxShape.circle,
                    ),
                    child: (widget.creation.sellerImage != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(widget.creation.sellerImage!),
                          )
                        : const Icon(Icons.person),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.creation.sellerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 72, 72, 72),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(width: Get.height * 0.04 + 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 1; i <= 5; i++)
                            Icon(
                              Icons.star,
                              color: AppColor.secYello,
                              size: 18,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: Get.width * 0.7,
                        child: const Text(
                          "The Indian rupee (symbol: ₹; code: INR) is the official currency in the Republic of India.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getBottomContainer() {
    return Expanded(
      child: Container(
        width: Get.width,
        color: const Color.fromARGB(255, 239, 239, 239),
        padding: EdgeInsets.all(AppPadding.edgePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Price"),
                Text(
                  "₹ ${widget.creation.price.toString()}",
                  style: AppText.bigHeddingStyle1b,
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        // margin: const EdgeInsets.only(right: 5),
                        height: Get.height * 0.06,
                        //padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.grey.shade500)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Buy Now",
                              style: AppText.heddingStyle2bBlack,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AddToCartPage(),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Text(
                              "Add To Cart",
                              style: AppText.heddingStyle2bWhite,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        SnackBar snackBar = const SnackBar(
                          content: Text("Product added"),
                          duration: Duration(milliseconds: 500),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget suggestCreationView() {
    return SizedBox(
      //color: Colors.red,
      height: 260.h,
      width: double.infinity.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
        physics: const BouncingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, index) {
          CreationInfoModel creation = widget.creation;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: GestureDetector(
              onTap: () {
                Get.to(ProductDetailsScreen(
                  creation: creation,
                ));
              },
              child: Container(
                width: 175.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(61, 157, 157, 163),
                        blurRadius: 5,
                        spreadRadius: 1,
                        // offset: Offset(1, -1),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 145.h,
                      width: 175.w,
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        child: Image.asset(
                          creation.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: Padding(
                      //   padding: EdgeInsets.only(
                      //       left: 10.w, right: 147.w, bottom: 142.h),
                      //   child: Container(
                      //       height: 20.h,
                      //       width: 20.w,
                      //       decoration: const BoxDecoration(
                      //           shape: BoxShape.circle, color: Colors.white),
                      //       child: Center(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             // toggle(index);
                      //           },
                      //           child: (true)
                      //               ? Image(
                      //                   image: AssetImage(
                      //                       "assets/saveboldblue.png"),
                      //                   height: 10.h,
                      //                   width: 9.w,
                      //                 )
                      //               : Image(
                      //                   image:
                      //                       AssetImage("assets/savebold.png"),
                      //                   height: 10.h,
                      //                   width: 9.w,
                      //                 ),
                      //         ),
                      //       )),
                      // ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.itermInsidePadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            creation.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp,
                              color: const Color(0XFF000000),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            creation.subtitle,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: const Color.fromARGB(255, 74, 74, 74),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
