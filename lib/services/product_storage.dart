import 'package:shared_preferences/shared_preferences.dart';

class ProductStorage {
  static const _key = 'user_product_ids';

  static Future<List<String>> getIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getIds();
    if (!ids.contains(id)) {
      ids.add(id);
      await prefs.setStringList(_key, ids);
    }
  }

  static Future<void> removeId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getIds();
    ids.remove(id);
    await prefs.setStringList(_key, ids);
  }
}