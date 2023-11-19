DateTime _parseDateTimeFromString(String date) {
  return DateTime.parse(date);
}

class Friends {
  final String userId;
  final DateTime friendSince;
  final String friendId;

  const Friends({
    required this.userId,
    required this.friendSince,
    required this.friendId,
  });

  factory Friends.fromJson(Map<String, dynamic> json) {
    return Friends(
      userId: json['user_id'],
      friendSince: _parseDateTimeFromString(json['friends_since']),
      friendId: json['friend_id'],
    );
  }
}
