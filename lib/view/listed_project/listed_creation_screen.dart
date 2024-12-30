import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/config/data_file.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/view/listed_project/list_new_creation_screen.dart';
import 'package:projecthub/widgets/creation_card.dart';
import 'package:provider/provider.dart';

class ListedProjectScreen extends StatefulWidget {
  const ListedProjectScreen({super.key});

  @override
  State<ListedProjectScreen> createState() => _ListedProjectScreenState();
}

class _ListedProjectScreenState extends State<ListedProjectScreen> {
  List<CreationInfoModel> _userListedCreations = [];
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  double _lastScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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

  getDate() {
    _userListedCreations =
        Provider.of<UserInfoProvider>(context).userListedCreations;
  }

  @override
  Widget build(BuildContext context) {
    getDate();
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(const ListNewCreationScreen());
        },
        enableFeedback: true,
        isExtended: true,
        label: Row(
          children: [
            const Icon(
              Icons.add,
            ),
            SizedBox(
              width: Get.width * 0.015,
            ),
            const Text(
              "List new creation",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
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
                "My listed creations",
                style: AppText.heddingStyle2bBlack,
              ),
            ),
            Expanded(
              child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppPadding.edgePadding),
                  itemCount: 6,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return CreatationCard(
                        creation: _userListedCreations[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchField() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _isSearchVisible ? 1 : 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: _isSearchVisible ? Get.height * 0.10 : 0,
        color: AppColor.bgColor,
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
        ));
  }
}
