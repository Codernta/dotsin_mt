import 'package:equatable/equatable.dart';

enum OrganSystem {
  cardiovascular,
  respiratory,
  neurological,
  digestive,
  renal,
  hematologic,
  genomic,
}

class OrganNode extends Equatable {
  final String id;
  final String title;
  final OrganSystem system;
  final double score; // 0 to 100
  final String status;
  final String summary;
  final String iconName;
  final double xPercent; // Normalized x on human torso (0.0 to 1.0)
  final double yPercent; // Normalized y on human torso (0.0 to 1.0)
  final String primaryColorHex;
  final String todayFocusTitle;
  final String todayFocusAction;

  const OrganNode({
    required this.id,
    required this.title,
    required this.system,
    required this.score,
    required this.status,
    required this.summary,
    required this.iconName,
    required this.xPercent,
    required this.yPercent,
    required this.primaryColorHex,
    required this.todayFocusTitle,
    required this.todayFocusAction,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        system,
        score,
        status,
        summary,
        iconName,
        xPercent,
        yPercent,
        primaryColorHex,
        todayFocusTitle,
        todayFocusAction,
      ];
}
