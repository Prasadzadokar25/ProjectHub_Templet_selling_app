import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:projecthub/app_providers/advertisement_provider.dart';
import 'package:projecthub/app_providers/categories_provider.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/model/advertisement_model.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/creation_model.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMoreCreations();
    }
  }

  Future<void> _loadMoreCreations() async {
    setState(() => _isLoadingMore = true);
    final userId =
        Provider.of<UserInfoProvider>(context, listen: false).user!.userId;
    await Provider.of<GeneralCreationProvider>(context, listen: false)
        .fetchMoreGeneralCreations(userId);
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: ListView(
        controller: _scrollController,
        children: [
          const SizedBox(height: 12),
          const _TopBar(),
          const SizedBox(height: 6),
          const _AdvertisementSlider(),
          const SizedBox(height: 18),
          _SectionHeader(
            leftTitle: "Categories",
            rightTitle: "See All",
            navigateTo: const CategoriesPage(),
          ),
          const _CategoriesSlider(),
          const SizedBox(height: 18),
          _SectionHeader(
            leftTitle: "Trending Creations",
            rightTitle: "See All",
            navigateTo: const AllCreationScreen(type: "trending"),
          ),
          const SizedBox(height: 8),
          const _TrendingCreationsView(),
          const SizedBox(height: 35),
          _SectionHeader(
            leftTitle: "Recently Added Creations",
            rightTitle: "See All",
            navigateTo: const AllCreationScreen(type: "recent"),
          ),
          const _RecentlyAddedCreationsView(),
          const SizedBox(height: 12),
          _SectionHeader(
            leftTitle: "Other",
            rightTitle: "See All",
            navigateTo: const AllCreationScreen(type: "other"),
          ),
          const SizedBox(height: 12),
          const _OtherCreationsView(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final Widget navigateTo;

  const _SectionHeader({
    required this.leftTitle,
    required this.rightTitle,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: () =>
                Get.to(navigateTo, transition: Transition.rightToLeftWithFade),
            child: Text(
              rightTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(
      builder: (context, provider, _) {
        final user = provider.user!;
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.to(() => const ProfileScreen()),
                child: CircleAvatar(
                  radius: Get.height * 0.028,
                  backgroundImage: user.profilePhoto != null
                      ? NetworkImage(ApiConfig.baseURL + user.profilePhoto!)
                      : null,
                  child: user.profilePhoto == null
                      ? const Icon(Icons.person,
                          size: 40, color: Colors.black45)
                      : null,
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: Get.width * 0.6,
                child: Text(
                  "Welcome, ${user.userName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: const Color(0XFF000000),
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_on,
                    color: Color(0XFF23408F)),
              ),
              const SizedBox(width: 2),
            ],
          ),
        );
      },
    );
  }
}

class _CategoriesSlider extends StatelessWidget {
  const _CategoriesSlider();

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          height: Get.height * 0.135,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(AppPadding.edgePadding),
            itemCount: provider.categories!.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) => _CategoryCard(
              category: provider.categories![index],
              height: (Get.height * 0.135) - 2 * AppPadding.edgePadding,
            ),
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final double height;

  const _CategoryCard({required this.category, required this.height});

  @override
  Widget build(BuildContext context) {
    const double radius = 15;
    return InkWell(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
        ),
        child: FutureBuilder<Color>(
          future: _getDominantColor(ApiConfig.getFileUrl(category.image!)),
          builder: (context, snapshot) {
            final color = snapshot.data ?? const Color(0XFFEBE2C9);
            return Container(
              height: height,
              width: height,
              padding: EdgeInsets.all(Get.height * 0.008),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.5,
                    child: Image.network(ApiConfig.getFileUrl(category.image!)),
                  ),
                  SizedBox(height: Get.height * 0.004),
                  Text(
                    category.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<Color> _getDominantColor(String imageUrl) async {
    final palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      maximumColorCount: 10,
    );
    return palette.dominantColor?.color ?? Colors.grey;
  }
}

class _AdvertisementSlider extends StatelessWidget {
  const _AdvertisementSlider();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdvertisementProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.advertisements.isEmpty) {
          return const Center(child: Text("No advertisements available."));
        }
        return CarouselSlider(
          options: CarouselOptions(
            height: Get.height * 0.19,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayInterval: const Duration(seconds: 4),
            aspectRatio: 1,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: provider.advertisements.map((ad) => _AdItem(ad)).toList(),
        );
      },
    );
  }
}

class _AdItem extends StatelessWidget {
  final AdvertisementModel ad;

  const _AdItem(this.ad);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () {},
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(ApiConfig.getFileUrl(ad.adImage!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrendingCreationsView extends StatelessWidget {
  const _TrendingCreationsView();

  @override
  Widget build(BuildContext context) {
    return Consumer<TreandingCreationProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 240.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: provider.threandingCreations!.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final creation = provider.threandingCreations![index];
              return _TrendingCreationItem(creation: creation);
            },
          ),
        );
      },
    );
  }
}

class _TrendingCreationItem extends StatelessWidget {
  final Creation2 creation;

  const _TrendingCreationItem({required this.creation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: () => Get.to(ProductDetailsScreen(creation: creation)),
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
                  topLeft: Radius.circular(9.h),
                  topRight: Radius.circular(9.h),
                ),
                child: SizedBox(
                  height: 120.h,
                  width: 200.w,
                  child: Image.network(
                    ApiConfig.getFileUrl(creation.creationThumbnail!),
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
                      creation.creationTitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: const Color(0XFF000000),
                      ),
                    ),
                    Text(
                      "by ${creation.seller!.sellerName!}",
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
  }
}

class _RecentlyAddedCreationsView extends StatelessWidget {
  const _RecentlyAddedCreationsView();

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentCreationProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 323.h,
          child: ListView.separated(
            padding: EdgeInsets.all(AppPadding.edgePadding),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: provider.recentlyAddedCreations!.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final creation = provider.recentlyAddedCreations![index];
              return _RecentlyAddedCreationItem(creation: creation);
            },
          ),
        );
      },
    );
  }
}

class _RecentlyAddedCreationItem extends StatelessWidget {
  final Creation2 creation;

  const _RecentlyAddedCreationItem({required this.creation});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(ProductDetailsScreen(creation: creation)),
      child: Container(
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
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9.h),
                  topRight: Radius.circular(9.h),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      ApiConfig.getFileUrl(creation.creationThumbnail!)),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.star_rate_rounded,
                          color: AppColor.secYello,
                          size: 15,
                        ),
                        Text(
                          creation.averageRating!.substring(0, 3),
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
                    creation.creationTitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                      color: const Color(0XFF000000),
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: Get.height * 0.02,
                        backgroundImage:
                            creation.seller!.sellerProfilePhoto != null
                                ? NetworkImage(ApiConfig.baseURL +
                                    creation.seller!.sellerProfilePhoto!)
                                : null,
                        child: creation.seller!.sellerProfilePhoto == null
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
                          creation.seller!.sellerName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFF23408F),
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0XFFE5ECFF),
                    ),
                    child: Center(
                      child: Text(
                        "₹ ${creation.creationPrice!}",
                        style: TextStyle(
                          color: const Color(0XFF23408F),
                          fontFamily: 'Gilroy',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

class _OtherCreationsView extends StatelessWidget {
  const _OtherCreationsView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralCreationProvider>(
      builder: (context, provider, _) {
        final isLoadingMore = context
                .dependOnInheritedWidgetOfExactType<_LoadingMoreIndicator>()
                ?.isLoadingMore ??
            false;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
          child: Column(
            children: [
              ...provider.generalCreations!
                  .map((creation) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () =>
                              Get.to(ProductDetailsScreen(creation: creation)),
                          child: CreatationCard(creation: creation),
                        ),
                      ))
                  .toList(),
              if (isLoadingMore) const CreationCardPlaceholder(),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingMoreIndicator extends InheritedWidget {
  final bool isLoadingMore;

  const _LoadingMoreIndicator({
    required this.isLoadingMore,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_LoadingMoreIndicator oldWidget) {
    return isLoadingMore != oldWidget.isLoadingMore;
  }
}
