// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_icons.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/model/incard_creation_model.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

import '../../app_providers/creation_provider.dart';
import '../../config/api_config.dart';

class AddToCartPage extends StatefulWidget {
  const AddToCartPage({super.key});

  @override
  State createState() {
    return _AddToCartPage();
  }
}

class _AddToCartPage extends State<AddToCartPage> {
  double subTotal = 0;
  double platFromFees = 0;
  double gstTax = 0;
  double platFromFeesPercentage = 10;
  double gstTaxPercentage = 3;
  @override
  void initState() {
    super.initState();
    Provider.of<InCardCreationProvider>(context, listen: false)
        .fetchInCardCreations(
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId);
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  getCost(List<InCardCreationInfo> creationList) {
    double subCost = 0;
    double gst = 0;
    double platFromFees = 0;

    for (int i = 0; i < creationList.length; i++) {
      double creationPrice =
          double.parse("${creationList[i].creation.creationPrice}");

      subCost = subCost + creationPrice;
      gst = gst +
          (creationPrice * creationList[i].creation.gstTaxPercentage!) / 100;
      platFromFees = platFromFees +
          (creationPrice * creationList[i].creation.platFromFees!) / 100;
    }

    // Round values to 2 decimal places
    this.subTotal = double.parse(subCost.toStringAsFixed(2));
    this.platFromFees = double.parse(platFromFees.toStringAsFixed(2));
    this.gstTax = double.parse(gst.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBar(
          backgroundColor: AppColor.bgColor,
          elevation: 0,
          title: const Text("Your Cart"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: AppIcon.backIcon,
                onPressed: _requestPop,
              );
            },
          ),
        ),
        body:
            Consumer<InCardCreationProvider>(builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (value.creations!.isEmpty) {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  height: 150.h,
                  width: 150.w,
                  child: Image.asset("assets/images/cart.png"),
                ),
                const SizedBox(height: 4),
                const Text("Your cart is empty"),
                AppPrimaryElevetedButton(
                    onPressed: () {}, title: "Browse Creations")
              ],
            ));
          }
          getCost(value.creations!);

          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppPadding.edgePadding,
                    right: AppPadding.edgePadding,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.creations!.length,
                    itemBuilder: (context, index) {
                      return getCreationCard(value.creations![index]);
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                      )
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.width * 0.2,
                        height: 3,
                        color: const Color.fromARGB(197, 194, 194, 194),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.edgePadding * 2),
                      child: Column(
                        children: [
                          _getPriceInfo("SubTotal", "$subTotal"),
                          _getPriceInfo("platFromFees", "$platFromFees"),
                          _getPriceInfo("GST Tax", "$gstTax"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 44, 44, 44),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "₹ ${subTotal + platFromFees + gstTax}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 44, 44, 44),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppPadding.edgePadding * 1.5,
                            ),
                            child: AppPrimaryElevetedButton(
                              onPressed: () {},
                              title: "CheckOut",
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  _getPriceInfo(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 105, 104, 104),
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "₹ $value",
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 105, 104, 104),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  getCreationCard(InCardCreationInfo inCardCreationInfo) {
    return Slidable(
      // actionPane: SlidableDrawerActionPane(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // removeItem(creation);
              // setState(() {});
            },
            icon: Icons.close,
            padding: EdgeInsets.zero,
            flex: 1,
            label: "Remove",
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 225, 225, 225),
              blurRadius: 10,
            )
          ],
        ),
        child: Material(
          color: Colors
              .transparent, // Set transparent background for ripple effect
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white, // Card background color
              borderRadius:
                  BorderRadius.circular(12), // Border radius for Ink effect
            ),
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(12), // Match the border radius
              hoverColor: const Color.fromARGB(
                  255, 145, 145, 145), // Slight black hover effect
              highlightColor: const Color.fromARGB(95, 119, 117, 117)
                  .withOpacity(0.2), // Slight black highlight effect
              splashColor: Colors.black.withOpacity(0.1), // Black splash color
              onTap: () {
                Get.to(ProductDetailsScreen(
                    creation: inCardCreationInfo.creation));
              },
              child: Padding(
                padding: EdgeInsets.all(AppPadding.edgePadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Get.height * 0.096,
                      width: Get.width * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: Colors
                            .grey.shade200, // Placeholder background color
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.network(
                          ApiConfig.getFileUrl(
                              inCardCreationInfo.creation.creationThumbnail!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: AppPadding
                            .itermInsidePadding), // Space between elements
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width * 0.4,
                          child: Text(
                            inCardCreationInfo.creation.creationTitle!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.4,
                          child: Text(
                            '\$${inCardCreationInfo.creation.creationPrice}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
