class Expense {
  final String id;
  final String payee, categoryId, note, tag;
  final DateTime date;
  final double amount;

  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.payee,
    required this.note,
    required this.date,
    required this.tag,
  });

  @override
  String toString() {
    return 'Expense(id: $id, amount: $amount, categoryId: $categoryId, payee: $payee, note: $note, date: $date, tag: $tag)';
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
        id: json['id'],
        payee: json['payee'],
        categoryId: json['catergoryId'],
        note: json['note'],
        tag: json['tag'],
        date: DateTime.parse(json['date']),
        amount: json['amount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payee': payee,
      'catergoryId': categoryId,
      'note': note,
      'tag': tag,
      'date': date.toIso8601String(),
      'amount': amount
    };
  }
}
