import 'package:projecthub/model/seller_model.dart';

class Creation2 {
  String? averageRating;
  int? categoryId;
  String? creationDescription;
  String? creationFile;
  int? creationId;
  String? creationOtherImages;
  String? creationPrice;
  String? creationThumbnail;
  String? creationTitle;
  String? keyword;
  int? numberOfReviews;
  String? createtime;
  Seller? seller;
  int? totalCopySell;
  double? gstTaxPercentage;
  double? platFromFees;

  Creation2({
    this.averageRating,
    this.categoryId,
    this.creationDescription,
    this.creationFile,
    this.creationId,
    this.creationOtherImages,
    this.creationPrice,
    this.creationThumbnail,
    this.creationTitle,
    this.keyword,
    this.numberOfReviews,
    this.seller,
    this.totalCopySell,
    this.createtime,
    this.gstTaxPercentage,
    this.platFromFees,
  });

  Creation2.fromJson(Map<String, dynamic> json) {
    averageRating = (json['average_rating'] is String)
        ? json['average_rating']
        : json['average_rating'].toString();
    categoryId = json['category_id'];
    creationDescription = json['creation_description'];
    creationFile = json['creation_file'];
    creationId = json['creation_id'];
    creationOtherImages = json['creation_other_images'];
    creationPrice = (json['creation_price'] is String)
        ? json['creation_price']
        : json['creation_price'].toString();
    creationThumbnail = json['creation_thumbnail'];
    creationTitle = json['creation_title'];
    keyword = json['keyword'];
    numberOfReviews = json['number_of_reviews'];
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    totalCopySell = json['total_copy_sell'];
    createtime = json['createtime'];
    gstTaxPercentage = json['gst_percentage'];
    platFromFees = json['platform_fee_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average_rating'] = averageRating;
    data['category_id'] = categoryId;
    data['creation_description'] = creationDescription;
    data['creation_file'] = creationFile;
    data['creation_id'] = creationId;
    data['creation_other_images'] = creationOtherImages;
    data['creation_price'] = creationPrice;
    data['creation_thumbnail'] = creationThumbnail;
    data['creation_title'] = creationTitle;
    data['keyword'] = keyword;
    data['number_of_reviews'] = numberOfReviews;
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    data['total_copy_sell'] = totalCopySell;
    data['gst_percentage'] = gstTaxPercentage;
    data['platform_fee_percentage'] = platFromFees;
    return data;
  }
}
