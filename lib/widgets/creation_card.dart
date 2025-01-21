import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/controller/files_download_controller.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/new.dart';
import 'package:projecthub/model/purched_creation_model.dart';
import 'package:share_plus/share_plus.dart';

class CreatationCard extends StatefulWidget {
  final Creation2 creation;
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
      //constraints: BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.h),
        boxShadow: [
          BoxShadow(
            color: const Color(0XFF23408F).withOpacity(0.24),
            offset: const Offset(-4, 5),
            blurRadius: 16.h,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.h),
              boxShadow: [
                BoxShadow(
                  color: const Color(0XFF23408F).withOpacity(0.14),
                  offset: const Offset(-4, 5),
                  blurRadius: 16.h,
                ),
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
                        topLeft: Radius.circular(9.h),
                        topRight: Radius.circular(9.h)),
                    child: Image(
                      image: NetworkImage(ApiConfig.getFileUrl(
                        widget.creation.creationThumbnail!,
                      )),
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
                      ),
                    ),
                  ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      height: 27.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.h),
                        color: const Color(0XFFFAF4E1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rate_rounded,
                            color: Color.fromARGB(255, 255, 196, 0),
                            size: 15,
                          ),
                          Text(
                            widget.creation.averageRating!.substring(0, 4),
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
                SizedBox(height: 11.h),
                Text(
                  widget.creation.creationTitle!,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      fontFamily: 'Gilroy',
                      color: const Color.fromARGB(255, 25, 25, 25)),
                ),
                SizedBox(height: 8.h),
                // if (widget.creation.creationDescription != null &&
                //     widget.creation.creationDescription! != "")
                //   Column(
                //     children: [
                //       Text(
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //         widget.creation.creationDescription!,
                //         style: TextStyle(
                //             fontWeight: FontWeight.w400,
                //             fontSize: 14.sp,
                //             fontFamily: 'Gilroy',
                //             color: const Color.fromARGB(255, 25, 25, 25)),
                //       ),
                //       SizedBox(height: 8.h),
                //     ],
                //   ),
                Row(
                  children: [
                    Container(
                      height: 40.h,
                      width: 40.h,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(163, 228, 228, 255),
                        shape: BoxShape.circle,
                      ),
                      child: (widget.creation.seller!.sellerProfilePhoto !=
                              null)
                          ? Image(
                              image: AssetImage(
                                  widget.creation.seller!.sellerProfilePhoto!),
                              height: 40.h,
                              width: 40.w,
                            )
                          : const Icon(Icons.person),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        maxLines: 2,
                        widget.creation.seller!.sellerName!,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0XFF23408F),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Gilroy'),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.h),
                          color: const Color(0XFFE5ECFF)),
                      child: Text(
                        "₹ ${widget.creation.creationPrice!}",
                        style: TextStyle(
                            color: const Color(0XFF23408F),
                            fontFamily: 'Gilroy',
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListedCreationCard extends StatefulWidget {
  final ListedCreation creation;
  const ListedCreationCard({super.key, required this.creation});

  @override
  State createState() => _ListedCreationCardState();
}

class _ListedCreationCardState extends State<ListedCreationCard> {
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
                      image: NetworkImage(widget.creation.creationThumbnail),
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
                      ),
                    ),
                  ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 11.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0.w),
                      child: Text(
                        widget.creation.creationTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                            fontFamily: 'Gilroy',
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    SizedBox(height: 11.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Listed Price : "),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 30.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.h),
                              color: const Color(0XFFE5ECFF)),
                          child: Center(
                            child: Text(
                              "₹ ${widget.creation.creationPrice.toString()}",
                              style: TextStyle(
                                  color: const Color(0XFF23408F),
                                  fontFamily: 'Gilroy',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Status : "),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 30.h,
                          //width: 74.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.h),
                              color: const Color(0XFFE5ECFF)),
                          child: Center(
                            child: Text(
                              "UnderReview",
                              style: AppText.subHeddingStyle,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PurchedCreationCard extends StatefulWidget {
  final PurchedCreationModel purchedCreationModel;
  const PurchedCreationCard({super.key, required this.purchedCreationModel});

  @override
  State<PurchedCreationCard> createState() => _PurchedCreationCardState();
}

class _PurchedCreationCardState extends State<PurchedCreationCard> {
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
                      image: NetworkImage(ApiConfig.getFileUrl(widget
                          .purchedCreationModel.creation.creationThumbnail!)),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width * 0.7,
                          child: Text(
                            widget.purchedCreationModel.creation.creationTitle!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp,
                              fontFamily: 'Gilroy',
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              FilesDownloadController().downloadZipFile(
                                widget.purchedCreationModel.creation,
                              );
                            },
                            icon: const Icon(Icons.download))
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Purched for : ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                        Text(
                          "₹${widget.purchedCreationModel.purchasePrice.toString()}",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Purched date : ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                        Text(
                          (widget.purchedCreationModel.orderDate).split(" ")[0],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        )
                      ],
                    ),
                    SizedBox(height: 11.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
