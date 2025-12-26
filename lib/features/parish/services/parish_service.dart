import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../../core/network/api_client.dart';
//import '../models/parish_model.dart';

/*class ParishService {
  final _box = GetStorage();
  static const _cacheKey = "cached_parishes";

  Future<List<PariModel>> fetchParishes() async {
    final response = await ApiClient.get("/paroisses");

    final decoded = jsonDecode(response.body) as List;

    // sauvegarde locale
    _box.write(
      _cacheKey,
      decoded,
    );

    return decoded.map((e) => ParishModel.fromJson(e)).toList();
  }

  List<ParishModel>? getCachedParishes() {
    final cached = _box.read(_cacheKey);
    if (cached == null) return null;

    return (cached as List)
        .map((e) => ParishModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}*/
