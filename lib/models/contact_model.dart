class Contact {
  final String id;
  final String name;
  final String number;

  Contact({
    required this.id,
    required this.name,
    required this.number,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id'] ?? '',
      name: json['contact_name'] ?? 'Unknown',
      number: json['contact_number'] ?? 'No number available',
    );
  }
}
