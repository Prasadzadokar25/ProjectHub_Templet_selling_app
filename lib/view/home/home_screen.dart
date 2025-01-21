import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/app_providers/data_file_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/new.dart';
import 'package:projecthub/view/app_shimmer.dart';
import 'package:projecthub/widgets/creation_card.dart';
import 'package:projecthub/view/home/categories_screen.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

import '../../app_providers/user_provider.dart';
import '../all_creation_screen/all_creation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Creation> adeverticmentIterm = [];

  List<CategoryModel> categories = [];

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
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

    setState(() {
      _isLoadingMore = false;
    });
  }

  void getData() async {
    DataFileProvider dataFileProvider = Provider.of<DataFileProvider>(context);
    adeverticmentIterm = dataFileProvider.adeverticmentIterm;

    categories = dataFileProvider.categories;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getData();
    log("here");
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: Image(
            image: const AssetImage("assets/images/user_image.png"),
            height: 50.h,
            width: 49.93.w,
          ),
        ),
        SizedBox(width: 10.w),
        Text("Welcome, Prasad",
            style: TextStyle(
                fontFamily: 'Gilroy',
                color: const Color(0XFF000000),
                fontSize: 22.sp,
                fontWeight: FontWeight.w700)),
        const Spacer(),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Color(0XFF23408F),
            ))
      ]),
    );
  }

  Widget getCategoriesSlider() {
    return SizedBox(
      height: Get.height * 0.135,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(AppPadding.edgePadding),
        itemBuilder: (context, index) => CategoryCard(
          subCategoryModel: categories[index],
          cellHeight: (Get.height * 0.135) - 2 * AppPadding.edgePadding,
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemCount: categories.length,
      ),
    );
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
            separatorBuilder: (context, index) => const SizedBox(width: 10),
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
                    width: 200.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
                        Container(
                          height: 145.h,
                          width: 200.w,

                          decoration: BoxDecoration(
                            //color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            child: Image.network(
                              ApiConfig.getFileUrl(
                                  trendingCreation.creationThumbnail!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          //alignment: Alignment.topLeft,
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
                                  color: Color.fromARGB(255, 92, 91, 91),
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
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemBuilder: (BuildContext context, index) {
              Creation2 recentAddedCreation =
                  value.recentlyAddedCreations![index];
              return GestureDetector(
                onTap: () {
                  Get.to(ProductDetailsScreen(creation: recentAddedCreation));
                },
                child: Container(
                  //height: 323,
                  width: 276.w,
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
                        height: 158.h,
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 25.h,
                              width: 58.w,
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
                          horizontal: 8.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (recentAddedCreation
                                        .seller!.sellerProfilePhoto !=
                                    null)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    child: Image(
                                      image: AssetImage(recentAddedCreation
                                          .seller!.sellerProfilePhoto!),
                                      height: 40.h,
                                      width: 40.w,
                                    ),
                                  ),
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
                                  horizontal: 8.w, vertical: 2),
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
                    ? Center(child: CreationCardPlaceholder())
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
  final CategoryModel? subCategoryModel;
  final double? cellHeight;

  const CategoryCard({super.key, this.subCategoryModel, this.cellHeight});

  static Future<Color> _updatePaletteGenerator(String imageName) async {
    ByteData imageBytes = await rootBundle.load(imageName);
    img.Image photo;
    photo = img.decodeImage(imageBytes.buffer.asUint8List())!;
    //log("imagesize==${photo.width}");
    Rect region =
        Offset.zero & Size(photo.width.toDouble(), photo.height.toDouble());

    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      AssetImage(imageName),
      size: Size(photo.width.toDouble(), photo.height.toDouble()),
      region: region,
      maximumColorCount: 10,
    );
    return paletteGenerator.colors.first
        .withOpacity(paletteGenerator.colors.first.computeLuminance());
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
                future: _updatePaletteGenerator(subCategoryModel!.image!),
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
                          height: cellHeight! * 0.55,
                          child: Image.asset(subCategoryModel!.image!),
                        ),
                        SizedBox(
                          height: Get.height * 0.004,
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          subCategoryModel!.name!,
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
