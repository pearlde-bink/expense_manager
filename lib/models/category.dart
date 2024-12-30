class Category {
  final String id;
  final String name;
  final bool isDefault; // To identify if it's a system default or user-added

  Category({required this.id, required this.name, this.isDefault = false});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
