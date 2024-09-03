class Comment {
  final String id;
  final String text;
  final String username;

  Comment({
    required this.id,
    required this.text,
    required this.username,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      text: json['text'],
      username: json['username'] ?? 'Unknown user',
    );
  }

  Comment copyWith({
    String? text,
    String? username,
  }) {
    return Comment(
      id: this.id,
      text: text ?? this.text,
      username: username ?? this.username,
    );
  }
}


class User {
  final String? id;
  final String? username;
  final String? profileImageUrl;

  User({this.id, this.username, this.profileImageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
