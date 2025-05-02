class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  final String createAt;

  Post({
    required this.id,
    required this.title,
    required this.body, 
    required this.userId,
    required this.createAt
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'], 
      userId: json['userId'],
      createAt: json['createAt']
    );
  }
}
