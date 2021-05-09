class Alert {
  int searchId;
  int activate;
  int hours;
  int minutes;

  Alert({this.searchId, this.activate, this.hours, this.minutes});
  factory Alert.fromJson(Map<String, dynamic> responseData) {
    return Alert(
      searchId: int.parse(responseData['data']['alert']['search_id']),
      activate: responseData['data']['alert']['activate'],
      hours:
          int.parse(responseData['data']['alert']['schedule'].substring(1, 2)),
      minutes:
          int.parse(responseData['data']['alert']['schedule'].substring(4, 5)),
    );
  }
}
