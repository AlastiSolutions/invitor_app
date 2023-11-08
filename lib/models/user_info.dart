DateTime _parseDateTimeFromString(String date) {
  return DateTime.parse(date);
}

// String _parseStringFromDateTime(DateTime date) {
//   return date.toString();
// }

class UserInfo {
  final String id;
  final DateTime createdAt;
  final String? username;

  const UserInfo({
    required this.id,
    required this.createdAt,
    this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      createdAt: _parseDateTimeFromString(json['created_at']),
      username: json['username'],
    );
  }
}
