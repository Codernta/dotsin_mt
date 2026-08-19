import 'package:equatable/equatable.dart';

class ProtocolItem extends Equatable {
  final String id;
  final String title;
  final String category; // 'Cardiovascular', 'Sleep', 'Nutrition', 'Recovery'
  final String impactLevel; // 'High Impact', 'Moderate Impact', 'Vitality'
  final String duration;
  final String impact;
  final bool isCompleted;
  final String iconName;
  final String description;

  const ProtocolItem({
    required this.id,
    required this.title,
    required this.category,
    this.impactLevel = 'High Impact',
    required this.duration,
    required this.impact,
    required this.isCompleted,
    required this.iconName,
    required this.description,
  });

  ProtocolItem copyWith({
    String? id,
    String? title,
    String? category,
    String? impactLevel,
    String? duration,
    String? impact,
    bool? isCompleted,
    String? iconName,
    String? description,
  }) {
    return ProtocolItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      impactLevel: impactLevel ?? this.impactLevel,
      duration: duration ?? this.duration,
      impact: impact ?? this.impact,
      isCompleted: isCompleted ?? this.isCompleted,
      iconName: iconName ?? this.iconName,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        impactLevel,
        duration,
        impact,
        isCompleted,
        iconName,
        description,
      ];
}
