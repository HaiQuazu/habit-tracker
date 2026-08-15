class Habit {
  final int? id;
  final String name;
  final String description;
  final String category;
  final String icon;
  final int color;
  final List<int> repeatDays;
  final bool isCompleted;
  final int currentStreak;
  final DateTime createdAt;

  const Habit({
    this.id,
    required this.name,
    this.description = '',
    required this.category,
    required this.icon,
    required this.color,
    required this.repeatDays,
    this.isCompleted = false,
    this.currentStreak = 0,
    required this.createdAt,
  });

  Habit copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    String? icon,
    int? color,
    List<int>? repeatDays,
    bool? isCompleted,
    int? currentStreak,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      repeatDays: repeatDays ?? this.repeatDays,
      isCompleted: isCompleted ?? this.isCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'icon': icon,
      'color': color,
      'repeatDays': repeatDays.join(','),
      'isCompleted': isCompleted ? 1 : 0,
      'currentStreak': currentStreak,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      icon: map['icon'] ?? 'check',
      color: map['color'] ?? 0xFF6C5CE7,
      repeatDays: (map['repeatDays'] ?? '')
          .toString()
          .split(',')
          .where((value) => value.isNotEmpty)
          .map(int.parse)
          .toList(),
      isCompleted: map['isCompleted'] == 1,
      currentStreak: map['currentStreak'] ?? 0,
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
    );
  }
}
