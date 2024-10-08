const String tableTodo = "todos";

class TodoFields {
  static final List<String> values = [
    id,
    title,
    description,
    createdTime,
  ];
  static const String id = "_id";
  static const String title = "title";
  static const String description = "description";
  static const String createdTime = "createdTime";
}

class Todo {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;

  const Todo({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.createdTime: createdTime.toIso8601String(),
      };

  Todo copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Todo fromJson(Map<String, Object?> json) => Todo(
        id: json[TodoFields.id] as int?,
        title: json[TodoFields.title] as String,
        description: json[TodoFields.description] as String,
        createdTime: DateTime.parse(json[TodoFields.createdTime] as String),
      );
}
