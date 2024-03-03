class GuestBook {
  String id;
  String estateId;
  String guest;
  String message;
  int rating;
  DateTime date;

  GuestBook({
    this.id = "",
    this.estateId = "",
    this.guest = "",
    this.message = "",
    this.rating = -1
  }) : this.date = DateTime.now();

  static GuestBook? toNotes(Map<String, dynamic>? card) {
    if (card == null) return null;

    GuestBook newcard = GuestBook();
    newcard.id = card['id'] ?? "";
    newcard.estateId = card['estateId'] ?? "";
    newcard.guest = card['guest'] ?? "";
    newcard.message = card['message'] ?? {};
    newcard.rating = card['rating'] ?? "";
    newcard.date = card['date'] ?? "";

    return newcard;
  }

  static Map<String, dynamic>? toJSON(GuestBook? card) {
    if (card == null) return null;

    return {
      "id": card.id,
      "estateId": card.estateId,
      "guest": card.guest,
      "message": card.message,
      "rating": card.rating,
      "date": card.date,
    };
  }

  static String asString(GuestBook? card) {
    if (card == null) return "";
    return "id: ${card.id}\nestateId: ${card.estateId}\nguest: ${card.guest}\nmessage: ${card.message}\nrating: ${card.rating}\ndate: ${card.date.millisecondsSinceEpoch}\n";
    // TODO: add links
  }
}
