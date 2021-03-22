class User {
  int userId;
  String name;
  String email;
  String image;
  String token;

  User({this.userId, this.name, this.email, this.image, this.token});
  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: int.parse(responseData['data']['id']),
        name: responseData['data']['name'],
        email: responseData['data']['email'],
        image: responseData['data']['image'],
        token: responseData['token']);
  }
}
