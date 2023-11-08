enum TicketType { basic, regular, vip }

TicketType _ticketTypeFromJson(String jsonEnumString) {
  if (jsonEnumString == 'basic') return TicketType.basic;
  if (jsonEnumString == 'regular') return TicketType.regular;
  return TicketType.vip;
}

DateTime _parseDateTimeFromString(String date) {
  return DateTime.parse(date);
}

// String _parseStringFromDateTime(DateTime date) {
//   return date.toString();
// }

class Ticket {
  final String id;
  final DateTime createdAt;
  final String eventId;
  final String userId;
  final TicketType ticketType;
  final double price;
  final DateTime purchasedAt;

  const Ticket({
    required this.id,
    required this.createdAt,
    required this.eventId,
    required this.userId,
    required this.ticketType,
    required this.price,
    required this.purchasedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      createdAt: _parseDateTimeFromString(json['created_at']),
      eventId: json['event_id'],
      userId: json['user_id'],
      ticketType: _ticketTypeFromJson(json['ticket_type']),
      price: json['price'],
      purchasedAt: _parseDateTimeFromString(json['purchased_at']),
    );
  }
}
