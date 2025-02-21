class ApiConfig {
  // static String baseURL = "https://projecthub.pythonanywhere.com";
  static String baseURL = "http://192.168.128.228:5000/";

  static String addUser = "$baseURL/addUser";
  static String checkNumber = "$baseURL/checkNumber";
  static String checkLogindetails = "$baseURL/checkLogin";
  static String listCreation = "$baseURL/listCreation";
  static String getUserDetailsByID = "$baseURL/getUser";
  static String userListedCreations = "$baseURL/userListedCreations";
  static String addCreationToCard = "$baseURL/creation/card/add";
  static String removeItemFromCard = "$baseURL//creation/card/remove";
  static String incardCreations = "$baseURL/creation/card/get/userid";
  static String getBankAccount = "$baseURL/accounts";
  static String addBankAccount = "$baseURL/add-bank-account";
  static String setPrimaryBankAccount = "$baseURL/set-primary-account";
  static String placeOrder = "$baseURL/create-order";
  static String categories = "$baseURL/categories";
  static String updateUser = "$baseURL/update_user";

  static String getGeneralCreationsUrl(int pageNo, [int perPage = 10]) {
    return "$baseURL/creations/page/$pageNo/perPage/$perPage/uid";
  }

  static String getRecentaddedCreationUrl(int pageNo, [int perPage = 10]) {
    return "$baseURL/recentCreations/page/$pageNo/perPage/$perPage/uid";
  }

  static String getTrendingCreations(int pageNo, [int perPage = 10]) {
    return "$baseURL/trendingCreations/page/$pageNo/perPage/$perPage/uid";
  }

  static String getRecomandedCreations(int pageNo, [int perPage = 10]) {
    return "$baseURL/recomandedCreations/page/$pageNo/perPage/$perPage/uid";
  }

  static String getPurchedCreations(int pageNo, [int perPage = 10]) {
    return "$baseURL/creation/purched/page/$pageNo/perPage/$perPage/uid";
  }

  static String getFileUrl(String path) {
    return "$baseURL/$path";
  }
}
