DateTime _parseDateTimeFromString(String date) {
  return DateTime.parse(date);
}

class Event {
  const Event({
    required this.id,
    required this.createdAt,
    required this.title,
    this.description,
    required this.date,
    required this.location,
    required this.organizerId,
    this.organizerEmail,
    required this.inviteCount,
    required this.rsvpCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      createdAt: _parseDateTimeFromString(json['created_at']),
      title: json['title'],
      description: json['description'],
      date: _parseDateTimeFromString(json['date']),
      location: json['location'],
      organizerId: json['organizer_id'],
      organizerEmail: json['organizer_email'],
      inviteCount: json['invite_count'],
      rsvpCount: json['rsvp_count'],
    );
  }

  // String toString() {
  //   return "$date : $title";
  // }

  final String id;
  final DateTime createdAt;
  final String title;
  final String? description;
  final DateTime date;
  final String location;
  final String organizerId;
  final String? organizerEmail;
  final int inviteCount;
  final int rsvpCount;
}
