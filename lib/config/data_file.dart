import 'package:flutter/foundation.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart' as lorem;

class DataFileProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  static List<Design> _categories = [
    Design(
      image: 'assets/images/d3.png',
      name: 'Design',
      //color: '0XFFFFF6E5',
    ),
    Design(
      image: 'assets/images/d4.png',
      name: 'Code',
      color: '0XFFFEE9EB',
    ),
    Design(
      image: 'assets/images/user_image.png',
      name: 'Video graphics',
      color: '0XFFECF6FF',
    ),
    Design(
      image: 'assets/images/d4.png',
      name: 'Code',
      color: '0XFFFEE9EB',
    ),
    Design(
      image: 'assets/images/user_image.png',
      name: 'Video graphics',
      color: '0XFFECF6FF',
    ),
    Design(
      image: 'assets/images/d3.png',
      name: 'Design',
      color: '0XFFFFF6E5',
    ),
    Design(
      image: 'assets/images/d4.png',
      name: 'Code',
      color: '0XFFFEE9EB',
    ),
    Design(
      image: 'assets/images/d5.png',
      name: 'Video graphics',
      color: '0XFFECF6FF',
    ),
    Design(
      image: 'assets/images/d6.png',
      name: 'Photography',
      color: '0XFFFFF6E5',
    ),
  ];
  // ignore: prefer_final_fields
  List<CreationInfoModel> _adeverticmentIterm = [
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/banner.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      sellerImage: "assets/images/user_image.png",
      rating: 4.8,
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/banner.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    )
  ];

  // ignore: prefer_final_fields
  List<CreationInfoModel> _trendingCreations = [
    CreationInfoModel(
      title: "Demo Product",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product2",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerName: "Prasad zadokar",
    ),
    CreationInfoModel(
      title: "Demo Product3",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product4",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerName: "Prasad zadokar",
    ),
    CreationInfoModel(
      title: "Demo Product",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
    )
  ];
  // ignore: prefer_final_fields
  List<CreationInfoModel> _recentlyaddedCreations = [
    CreationInfoModel(
      title: "Demo Product",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product2",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product3",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product4",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    )
  ];

  // ignore: prefer_final_fields
  List<CreationInfoModel> _otherCreations = [
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Demo Product2",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product3",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product4",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product demo ,Demo Product demo,demodsmshgsh ",
      subtitle:
          "my demo pmy demo productmy demo productmy demo productmy demo productroduct",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    )
  ];
  List<CreationInfoModel> get adeverticmentIterm => _adeverticmentIterm;
  List<CreationInfoModel> get trendingCreations => _trendingCreations;
  List<CreationInfoModel> get recentlyAddedCreations => _recentlyaddedCreations;
  List<CreationInfoModel> get otherCreations => _otherCreations;
  List<Design> get categories => _categories;
}

class UserInfoProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<CreationInfoModel> _userListedCreations = [
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Creatation title",
      price: 400,
      subtitle: lorem.loremIpsum(paragraphs: 3),
      imagePath: "assets/images/c1.jpg",
      rating: 4.8,
      sellerImage: "assets/images/user_image.png",
      sellerName: "prasad zadokar",
    ),
    CreationInfoModel(
      title: "Demo Product2",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product3",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product4",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    ),
    CreationInfoModel(
      title: "Demo Product",
      subtitle: "my demo product",
      price: 400,
      imagePath: "assets/images/d3.png",
      rating: 4.8,
      sellerName: "Prasad zadokar",
      sellerImage: "assets/images/user_image.png",
    )
  ];

  List<CreationInfoModel> get userListedCreations => _userListedCreations;
}
