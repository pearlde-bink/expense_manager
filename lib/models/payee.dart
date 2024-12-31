class Payee {
  final String id;
  final String name;

  const Payee({required this.id, required this.name});

  factory Payee.fromJson(Map<String, dynamic> json) {
    return Payee(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
