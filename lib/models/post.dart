import 'comment_model.dart';

class Post {
  String? id;
  String? title;
  String? body;
  String? image;
  DateTime? createdAt;
  List<Comment>? comments;
  int likes; // Removed final or late modifier

  Post({
    this.id,
    this.title,
    this.body,
    this.image,
    this.createdAt,
    this.comments,
    this.likes = 0, // Initialized with default value
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      body: json['body'],
      image: json['image'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      comments: json['comments'] != null
          ? (json['comments'] as List).map((i) => Comment.fromJson(i)).toList()
          : [],
      likes: json['likes'] ?? 0,
    );
  }

  void addLike() {
    likes++;
  }

  void removeLike() {
    likes--;
  }
}
