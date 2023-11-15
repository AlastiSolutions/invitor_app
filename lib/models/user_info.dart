DateTime _parseDateTimeFromString(String date) {
  return DateTime.parse(date);
}

// String _parseStringFromDateTime(DateTime date) {
//   return date.toString();
// }

class UserInfo {
  final String id;
  final String? firstName;
  final String? lastName;
  final DateTime createdAt;
  final String? username;

  const UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      createdAt: _parseDateTimeFromString(json['created_at']),
      username: json['username'],
    );
  }
}
