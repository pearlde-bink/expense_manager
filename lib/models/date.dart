import 'package:intl/intl.dart';

class DateExpense {
  final String id;
  final int year;
  final int month;
  final int day;

  const DateExpense(
      {required this.id,
      required this.year,
      required this.month,
      required this.day});

  @override
  String toString() =>
      DateFormat('yyyy-MM-dd').format(DateTime(year, month, day));

  @override
  int get hashCode => Object.hash(year, month, day);

  // Add a method to convert DateExpense to DateTime
  DateTime toDateTime() => DateTime(year, month, day);
}
