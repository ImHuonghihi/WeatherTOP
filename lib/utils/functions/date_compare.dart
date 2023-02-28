bool compareDate(
  DateTime date1,
  DateTime date2, {
  String compareType = '=',
  List<String> compareTarget = const [
    'second',
    'minute',
    'hour',
    'day',
    'month',
    'year'
  ],
}) {

  bool result = false;
  switch (compareType) {
    case '=':
      result = isEqualDate(date1, date2, compareTarget);
      break;
    case '>':
      result = isGreaterThan(date1, date2, compareTarget);
      break;
    case '<':
      result = isLessThan(date1, date2, compareTarget);
      break;
    case '>=':
      result = isGreaterThanOrEqual(date1, date2, compareTarget);
      break;
    case '<=':
      result = isLessThanOrEqual(date1, date2, compareTarget);
      break;
    default:
      result = false;
  }
  return result;
}

bool isEqualDate(DateTime date1, DateTime date2, List<String >compareTarget) {
  bool result = false;
  if (compareTarget.contains('second')) {
    result = date1.second == date2.second;
  }
  if (compareTarget.contains('minute')) {
    result = date1.minute == date2.minute;
  }
  if (compareTarget.contains('hour')) {
    result = date1.hour == date2.hour;
  }
  if (compareTarget.contains('day')) {
    result = date1.day == date2.day;
  }
  if (compareTarget.contains('month')) {
    result = date1.month == date2.month;
  }
  if (compareTarget.contains('year')) {
    result = date1.year == date2.year;
  }
  return result;
}

bool isGreaterThan(DateTime date1, DateTime date2, List<String >compareTarget) {
  bool result = false;
  if (compareTarget.contains('second')) {
    result = date1.second > date2.second;
  }
  if (compareTarget.contains('minute')) {
    result = date1.minute > date2.minute;
  }
  if (compareTarget.contains('hour')) {
    result = date1.hour > date2.hour;
  }
  if (compareTarget.contains('day')) {
    result = date1.day > date2.day;
  }
  if (compareTarget.contains('month')) {
    result = date1.month > date2.month;
  }
  if (compareTarget.contains('year')) {
    result = date1.year > date2.year;
  }
  return result;
}

bool isLessThan(DateTime date1, DateTime date2, List<String >compareTarget) {
  bool result = false;
  if (compareTarget.contains('second')) {
    result = date1.second < date2.second;
  }
  if (compareTarget.contains('minute')) {
    result = date1.minute < date2.minute;
  }
  if (compareTarget.contains('hour')) {
    result = date1.hour < date2.hour;
  }
  if (compareTarget.contains('day')) {
    result = date1.day < date2.day;
  }
  if (compareTarget.contains('month')) {
    result = date1.month < date2.month;
  }
  if (compareTarget.contains('year')) {
    result = date1.year < date2.year;
  }
  return result;
}

bool isGreaterThanOrEqual(DateTime date1, DateTime date2, List<String >compareTarget) {
  bool result = false;
  if (compareTarget.contains('second')) {
    result = date1.second >= date2.second;
  }
  if (compareTarget.contains('minute')) {
    result = date1.minute >= date2.minute;
  }
  if (compareTarget.contains('hour')) {
    result = date1.hour >= date2.hour;
  }
  if (compareTarget.contains('day')) {
    result = date1.day >= date2.day;
  }
  if (compareTarget.contains('month')) {
    result = date1.month >= date2.month;
  }
  if (compareTarget.contains('year')) {
    result = date1.year >= date2.year;
  }
  return result;
}

bool isLessThanOrEqual(DateTime date1, DateTime date2, List<String >compareTarget) {
  bool result = false;
  if (compareTarget.contains('second')) {
    result = date1.second <= date2.second;
  }
  if (compareTarget.contains('minute')) {
    result = date1.minute <= date2.minute;
  }
  if (compareTarget.contains('hour')) {
    result = date1.hour <= date2.hour;
  }
  if (compareTarget.contains('day')) {
    result = date1.day <= date2.day;
  }
  if (compareTarget.contains('month')) {
    result = date1.month <= date2.month;
  }
  if (compareTarget.contains('year')) {
    result = date1.year <= date2.year;
  }
  return result;
}
