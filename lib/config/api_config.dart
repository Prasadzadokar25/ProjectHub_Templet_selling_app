class ApiConfig {
  // static String baseURL = "https://projecthub.pythonanywhere.com";
  static String baseURL = "http://192.168.32.119:5000";

  static String addUser = "$baseURL/addUser";
  static String checkNumber = "$baseURL/checkNumber";
  static String checkLogindetails = "$baseURL/checkLogin";
  static String listCreation = "$baseURL/listCreation";
  static String getUserDetailsByID = "$baseURL/getUser";
  static String userListedCreations = "$baseURL/userListedCreations";
  static String getGeneralCreations = "$baseURL/creations";

  static String getGeneralCreationsUrl(int pageNo, [int perPage = 10]) {
    return "$getGeneralCreations/page/$pageNo/perPage/$perPage/uid";
  }
}
