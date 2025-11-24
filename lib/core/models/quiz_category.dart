import 'package:equatable/equatable.dart';

class QuizCategory extends Equatable {
  const QuizCategory({
    required this.id,
    required this.name,
    required this.iconName,
  });

  final String id;
  final String name;
  final String iconName;

  QuizCategory copyWith({
    String? id,
    String? name,
    String? iconName,
  }) {
    return QuizCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconName': iconName,
      };

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, iconName];
}
