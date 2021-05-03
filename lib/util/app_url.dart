class AppUrl {
  static const String liveBaseURL = "";
  static const String localBaseURL = "http://192.168.1.71:80/api";

  //main route, this route is used in each call to the backend below
  static const String baseURL = localBaseURL;

  //user routes
  static const String login = baseURL + "/login";
  static const String getUser = baseURL + "/loggedUser";
  static const String register = baseURL + "/sign-up";
  static const String updateUser = baseURL + "/user/update/";
  static const String userImage = baseURL + "/userImage/";

  //searches routes
  static const String addNewSearch = baseURL + "/search";
}
