import '../models/mass_model.dart';
import '../models/mock_masses.dart';

class MassService {
  static Future<List<MassModel>> fetchMasses() async {
    // plus tard : appel API
    await Future.delayed(const Duration(milliseconds: 300));
    return mockMasses;
  }
}