class AppUrl {
  static const String liveBaseURL = "";
  static const String localBaseURL = "http://192.168.1.76:80/api";

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
  static const String getSearches = baseURL + "/searches/";
  static const String getRecentSearches = baseURL + "/recent/searches/";
  static const String getSearch = baseURL + "/search/";
  static const String updateSearch = baseURL + "/search/";
  static const String deleteSearch = baseURL + "/search/";

  //alerts routes
  static const String addNewAlert = baseURL + "/alert";
  static const String getAlert = baseURL + "/alert/";
  static const String getAlertId = baseURL + "/alertId/";
  static const String updateAlert = baseURL + "/alert/";

  //search_instance routes
  static const String addNewSearchInstance = baseURL + "/sInstance";
  static const String updateSearchInstance = baseURL + "/sInstance/";
}
