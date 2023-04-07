import 'package:weather/presentation/plan_screen/ProjectsPage/ProgressCard.dart';

class Plan {
  final int id;
  final String title;
  final String description;
  final String date;
  final String category;
  int progress = 0;
  bool isDone = false;

  Plan({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.progress = 0,
    this.isDone = false,
  });

  static Plan fromMap(Map<String, dynamic> dataMap) => Plan(
        id: dataMap['id'],
        title: dataMap['title'],
        description: dataMap['description'],
        category: dataMap['category'],
        date: dataMap['date'],
        progress: dataMap['progress'],
        isDone: dataMap['isDone'] == 1,
      );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'progress': progress,
      'isDone': isDone ? 1 : 0,
    };
  }

  ProgressCard toProgressCard() => ProgressCard(
        ProjectName: title,
        CompletedPercent: progress,
      );
}