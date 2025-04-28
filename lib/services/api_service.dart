import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://api.restful-api.dev/objects';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  static Future<List<Product>> getUserProducts(List<String> ids) async {
    if (ids.isEmpty) return [];
    
    final query = ids.map((id) => 'id=$id').join('&');
    final response = await http.get(Uri.parse('$baseUrl?$query'));
    
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos del usuario: ${response.statusCode}');
    }
  }

  static Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear producto: ${response.statusCode}');
    }
  }

  static Future<Product> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar producto: ${response.statusCode}');
    }
  }

  static Future<bool> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar producto: ${response.statusCode}');
    }
  }
}