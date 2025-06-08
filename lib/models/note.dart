class Note {
  final String id;
  final String title;
  final String description;
  final String? status;
  final String? priority;
  final String? deadline;
  final String? userId;

  Note({
    required this.id,
    required this.title,
    required this.description,
    this.status,
    this.priority,
    this.deadline,
    this.userId,
  });

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'],
      priority: map['priority'],
      deadline: map['deadline'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'deadline': deadline,
      if (userId != null) 'userId': userId,
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? deadline,
    String? userId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      userId: userId ?? this.userId,
    );
  }
}
