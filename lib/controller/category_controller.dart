// import 'package:projecthub/model/categories_info_model.dart';
// import 'package:http/http.dart' as http;

// import '../config/api_config.dart';


// class CategoryController{
//     Future<List<CategoryModel>> fetchPurchedCreations(
//       int userId, int page, int perPage) async {
//     try {
//       final response = await http.get(
//           Uri.parse("${ApiConfig.getPurchedCreations(page, perPage)}/$userId"));
//       log(response.body);
//       if (response.statusCode == 200) {
//         log("pppppp");
//         List<dynamic> data = jsonDecode(response.body)['data'];

//         return data.map((json) => PurchedCreationModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load creations');
//       }
//     } catch (e) {
//       throw Exception('Failed to load creations: $e');
//     }
//   }
// }