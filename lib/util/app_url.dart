class AppUrl {
  static const String liveBaseURL = "";
  static const String localBaseURL = "http://192.168.1.74:80/api";

  static const String baseURL = localBaseURL;

  static const String login = baseURL + "/login";
  static const String getUser = baseURL + "/loggedUser";
  static const String register = baseURL + "/sign-up";
  // static const String forgotPassword = baseURL + "/forgot-password";
}
