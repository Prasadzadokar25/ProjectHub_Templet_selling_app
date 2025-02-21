import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:projecthub/app_providers/categories_provider.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/app_providers/data_file_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/new.dart';
import 'package:projecthub/view/app_shimmer.dart';
import 'package:projecthub/view/profile/profile_screen.dart';
import 'package:projecthub/widgets/creation_card.dart';
import 'package:projecthub/view/home/categories_screen.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../app_providers/user_provider.dart';
import '../all_creation_screen/all_creation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Creation> adeverticmentIterm = [];

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            (_scrollController.position.maxScrollExtent) &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      _fetchNextCreations();
    }
  }

  Future<void> _fetchNextCreations() async {
    await Provider.of<GeneralCreationProvider>(context, listen: false)
        .fetchMoreGeneralCreations(
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingMore = false;
    });
  }

  void getData() async {
    DataFileProvider dataFileProvider = Provider.of<DataFileProvider>(context);
    adeverticmentIterm = dataFileProvider.adeverticmentIterm;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListView(
          controller: _scrollController,
          children: [
            SizedBox(height: Get.height * 0.012),
            getTopBar(),
            SizedBox(height: Get.height * 0.006),
            AdverticmentSlider(item: adeverticmentIterm),
            SizedBox(height: Get.height * 0.018),
            getSectionHedding(
              leftTitle: "Categories",
              rightTitle: "See All",
              navigateTo: const CategoriesPage(),
            ),
            getCategoriesSlider(),
            SizedBox(height: Get.height * 0.018),
            getSectionHedding(
              leftTitle: "Trending Creations",
              rightTitle: "See All",
              navigateTo: const AllCreationScreen(type: "trending"),
            ),
            SizedBox(height: Get.height * 0.008),
            trendingCreationView(),
            SizedBox(height: Get.height * 0.035),
            getSectionHedding(
              leftTitle: "Recently Added Creations",
              rightTitle: "See All",
              navigateTo: const AllCreationScreen(type: "recent"),
            ),
            getRecentlyAddedCreationView(),
            SizedBox(height: Get.height * 0.012),
            getSectionHedding(
              leftTitle: "Other",
              rightTitle: "See All",
              navigateTo: const AllCreationScreen(type: "other"),
            ),
            SizedBox(height: Get.height * 0.012),
            getOtherCreationView(),
            SizedBox(height: Get.height * 0.012),
          ],
        ),
      )),
    );
  }

  Widget getSectionHedding(
      {required String leftTitle,
      required String rightTitle,
      required Widget navigateTo}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
      child: Row(
        children: [
          Text(
            leftTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Gilroy',
            ),
          ),
          const Spacer(),
          InkWell(
            child: Text(
              rightTitle,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Gilroy',
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Get.to(navigateTo);
            },
          )
        ],
      ),
    );
  }

  Widget getTopBar() {
    return Consumer<UserInfoProvider>(builder: (context, value, child) {
      return Row(children: [
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            Get.to(() => const ProfileScreen());
          },
          child: CircleAvatar(
            radius: Get.height * 0.028,
            backgroundImage: (value.user!.profilePhoto != null)
                ? NetworkImage(ApiConfig.baseURL + value.user!.profilePhoto!)
                : null,
            child: (value.user!.profilePhoto == null)
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black45,
                  )
                : null,
          ),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: Get.width * 0.6,
          child: Text("Welcome, ${value.user!.userName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: const Color(0XFF000000),
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w700)),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_on,
            color: Color(0XFF23408F),
          ),
        ),
        const SizedBox(width: 2),
      ]);
    });
  }

  Widget getCategoriesSlider() {
    return Consumer<CategoriesProvider>(builder: (context, value, child) {
      if (value.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return SizedBox(
        height: Get.height * 0.135,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.normal),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(AppPadding.edgePadding),
          itemBuilder: (context, index) => CategoryCard(
            category: value.categories![index],
            cellHeight: (Get.height * 0.135) - 2 * AppPadding.edgePadding,
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemCount: value.categories!.length,
        ),
      );
    });
  }

  Widget trendingCreationView() {
    return Consumer<TreandingCreationProvider>(
        builder: (context, value, child) {
      return SizedBox(
        //color: Colors.red,
        height: 240.h,
        width: double.infinity.w,
        child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
            physics: const BouncingScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: value.threandingCreations!.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (BuildContext context, index) {
              Creation2 trendingCreation = value.threandingCreations![index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: GestureDetector(
                  onTap: () {
                    Get.to(ProductDetailsScreen(
                      creation: trendingCreation,
                    ));
                  },
                  child: Container(
                    width: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.h),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(77, 157, 157, 163),
                          blurRadius: 4,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(9.h),
                              topLeft: Radius.circular(9.h)),
                          child: SizedBox(
                            height: 120.h,
                            width: 200.w,
                            child: Image.network(
                              ApiConfig.getFileUrl(
                                  trendingCreation.creationThumbnail!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trendingCreation.creationTitle!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                    color: const Color(0XFF000000)),
                              ),
                              Text(
                                "by ${trendingCreation.seller!.sellerName!}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: const Color.fromARGB(255, 92, 91, 91),
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
            }),
      );
    });
  }

  Widget getRecentlyAddedCreationView() {
    return Consumer<RecentCreationProvider>(builder: (context, value, child) {
      return SizedBox(
        //color: const Color(0XFFFFFFFF),
        height: 323.h,
        width: double.infinity.w,
        child: ListView.separated(
            padding: EdgeInsets.all(AppPadding.edgePadding),
            physics: const BouncingScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            itemCount: value.recentlyAddedCreations!.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (BuildContext context, index) {
              Creation2 recentAddedCreation =
                  value.recentlyAddedCreations![index];
              return GestureDetector(
                onTap: () {
                  Get.to(ProductDetailsScreen(creation: recentAddedCreation));
                },
                child: Container(
                  //height: 323,
                  width: 266.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.h),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0XFF23408F).withOpacity(0.14),
                          offset: const Offset(-4, 5),
                          blurRadius: 16,
                        ),
                      ],
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 160.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(9.h),
                              topRight: Radius.circular(9.h)),
                          image: DecorationImage(
                            image: NetworkImage(
                              ApiConfig.getFileUrl(
                                recentAddedCreation.creationThumbnail!,
                              ),
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.h, vertical: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 25.h,
                              width: 58.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0XFFFAF4E1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.star_rate_rounded,
                                    color: AppColor.secYello,
                                    size: 15,
                                  ),
                                  Text(
                                    recentAddedCreation.averageRating!
                                        .substring(0, 3),
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: AppColor.secYello,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 11.h),
                            Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              recentAddedCreation.creationTitle!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.sp,
                                  color: const Color(0XFF000000),
                                  fontFamily: 'Gilroy'),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: Get.height * 0.02,
                                  backgroundImage: (recentAddedCreation
                                              .seller!.sellerProfilePhoto !=
                                          null)
                                      ? NetworkImage(ApiConfig.baseURL +
                                          recentAddedCreation
                                              .seller!.sellerProfilePhoto!)
                                      : null,
                                  child: (recentAddedCreation
                                              .seller!.sellerProfilePhoto ==
                                          null)
                                      ? const Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.black45,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    recentAddedCreation.seller!.sellerName!,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0XFF23408F),
                                        fontSize: 15.sp),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.h, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0XFFE5ECFF),
                              ),
                              child: Center(
                                  child: Text(
                                "₹ ${recentAddedCreation.creationPrice!}",
                                style: TextStyle(
                                    color: const Color(0XFF23408F),
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              )),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }

  Widget getOtherCreationView() {
    return Consumer<GeneralCreationProvider>(
      builder: (context, value, child) {
        log("${value.generalCreations!.length}mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
          child: Column(
            children:
                List.generate(value.generalCreations!.length + 3, (index) {
              if (index >= value.generalCreations!.length) {
                return _isLoadingMore
                    ? const Center(child: CreationCardPlaceholder())
                    : const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                    onTap: () {
                      Get.to(ProductDetailsScreen(
                          creation: value.generalCreations![index]));
                    },
                    child: CreatationCard(
                        creation: value.generalCreations![index])),
              );
            }),
          ),
        );
      },
    );
  }
}

class AdverticmentSlider extends StatefulWidget {
  final List<Creation> item;
  const AdverticmentSlider({super.key, required this.item});

  @override
  State<AdverticmentSlider> createState() => _AdverticmentSliderState();
}

class _AdverticmentSliderState extends State<AdverticmentSlider> {
  List<Widget> adverticementSliderWidgets = [];

  @override
  Widget build(BuildContext context) {
    adverticementSliderWidgets = widget.item
        .map((item) => Container(
              margin: const EdgeInsets.all(7),
              child: InkWell(
                onTap: () {},
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          // margin: EdgeInsets.all(
                          //     MediaQuery.of(context).size.width * 0.05),
                          //
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: ExactAssetImage(item.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ))
        .toList();
    return CarouselSlider(
      options: CarouselOptions(
          height: Get.height * 0.21,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(seconds: 1),
          autoPlayInterval: const Duration(seconds: 4),
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {});
          },
          enlargeStrategy: CenterPageEnlargeStrategy.height),
      items: adverticementSliderWidgets,
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel? category;
  final double? cellHeight;

  const CategoryCard({super.key, this.category, this.cellHeight});

  static Future<Color> getDominantColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      maximumColorCount: 10, // Increases accuracy
    );

    return paletteGenerator.dominantColor?.color ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    //double imageSize = Get.height * 0.13;
    double radius = 15;
    // double bottomRemainSize = cellHeight! - imageSize;

    return InkWell(
      child: Container(
        height: cellHeight,
        // margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Color>(
                future:
                    getDominantColor(ApiConfig.getFileUrl(category!.image!)),
                //This function return color from Sqlite DB Asynchronously
                builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                  Color color;
                  if (snapshot.hasData) {
                    color = snapshot.data!;
                  } else {
                    color = const Color.fromARGB(255, 235, 226, 201);
                  }

                  return Container(
                    alignment: Alignment.center,
                    height: cellHeight,
                    width: cellHeight,
                    //margin: const EdgeInsets.all(10),
                    padding: EdgeInsets.all(Get.height * 0.008),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: cellHeight! * 0.50,
                          child: Image.network(
                              "${ApiConfig.getFileUrl(category!.image!)}"),
                        ),
                        SizedBox(
                          height: Get.height * 0.004,
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          category!.name!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
      onTap: () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => SubCategoriesPage(subCategoryModel!.id)));
      },
    );
  }
}
