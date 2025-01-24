import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/widgets/creation_card.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  double _lastScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Provider.of<PurchedCreationProvider>(context, listen: false)
        .fetchUserPurchedCreation(
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
            1,
            10);
  }

  void _onScroll() {
    double currentOffset = _scrollController.position.pixels;

    if (currentOffset > _lastScrollOffset && _isSearchVisible) {
      // Scrolling down - hide search field
      setState(() {
        _isSearchVisible = false;
      });
    } else if (currentOffset < _lastScrollOffset && !_isSearchVisible) {
      // Scrolling up - show search field
      setState(() {
        _isSearchVisible = true;
      });
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSearchField(),
            Padding(
              padding: EdgeInsets.only(
                  left: AppPadding.edgePadding,
                  right: AppPadding.edgePadding,
                  top: AppPadding.edgePadding,
                  bottom: AppPadding.edgePadding * 0.6),
              child: Text(
                "My puchesed creations",
                style: AppText.heddingStyle2bBlack,
              ),
            ),
            Expanded(
              child: Consumer<PurchedCreationProvider>(
                  builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage.isNotEmpty) {
                  return Center(child: Text(provider.errorMessage));
                }

                if (provider.purchedCreations!.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150.h,
                        width: 150.w,
                        child: SvgPicture.asset(
                            "assets/images/no_creation_found.svg"),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "You did't purched anything",
                        style: AppText.heddingStyle2bBlack,
                      ),
                    ],
                  ));
                }
                return ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.all(AppPadding.edgePadding),
                    itemCount: provider.purchedCreations!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      return PurchedCreationCard(
                          purchedCreationModel:
                              provider.purchedCreations![index]);
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchField() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isSearchVisible ? 1 : 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isSearchVisible ? Get.height * 0.10 : 0,
        color: Colors.white,
        child: _isSearchVisible
            ? Padding(
                padding: EdgeInsets.all(AppPadding.edgePadding),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: AppTextfieldBorder.focusedBorder,
                    contentPadding: const EdgeInsets.all(8),
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        showFilters();
                      },
                      icon: const Icon(Icons.filter_list),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  showFilters() {
    Get.defaultDialog(
      title: "Filters",
      content: const Column(
        children: [
          ListTile(title: Text("Latest first")),
          ListTile(title: Text("Oldest first")),
          ListTile(title: Text("Most popular first")),
        ],
      ),
    );
  }
}
