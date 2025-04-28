class Product {
  final String id;
  final String name;
  final Map<String, dynamic> data;

  Product({
    required this.id,
    required this.name,
    required this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }

  static Product empty() {
    return Product(
      id: '',
      name: '',
      data: {
        'year': null,
        'price': null,
        'CPU model': '',
        'Hard disk size': '',
      },
    );
  }
}