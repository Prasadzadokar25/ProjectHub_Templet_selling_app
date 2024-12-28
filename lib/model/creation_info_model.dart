class CreationInfoModel {
  String title;
  String subtitle;
  String imagePath;
  double price;
  double rating;
  String sellerName;
  String? sellerImage;

  // Constructor
  CreationInfoModel(
      {required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.price,
      required this.rating,
      required this.sellerName,
      this.sellerImage});
}
