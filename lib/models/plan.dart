import 'package:weather/presentation/plan_screen/ProjectsPage/ProgressCard.dart';

class Plan {
  int? id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String category;
  int progress = 0;
  bool isDone = false;

  Plan({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
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
        time: dataMap['time'],
        progress: dataMap['progress'],
        isDone: dataMap['isDone'] == 1,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'title': title,
      'description': description,
      'category': category,
      'date': date,
      'time': time,
      'progress': progress,
      'isDone': isDone ? 1 : 0,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  ProgressCard toProgressCard() => ProgressCard(
        ProjectName: title,
        CompletedPercent: progress,
      );
  
  ScrollProgressCard toScrollProgressCard({void Function()? onTap, void Function(String?)? onOptionTap}) => ScrollProgressCard(
        ProjectName: title,
        CompletedPercent: progress,
        onCardTap: onTap,
        onOptionTap: onOptionTap,
      );
}
