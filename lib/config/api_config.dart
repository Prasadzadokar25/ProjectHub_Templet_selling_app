class ApiConfig {
  // static String baseURL = "https://projecthub.pythonanywhere.com";
  static String baseURL = "http://192.168.0.104:5000";

  static String addUser = "$baseURL/addUser";
  static String checkNumber = "$baseURL/checkNumber";
  static String checkLogindetails = "$baseURL/checkLogin";
  static String listCreation = "$baseURL/listCreation";
  static String getUserDetailsByID = "$baseURL/getUser";
}
