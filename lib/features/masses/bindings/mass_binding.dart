import 'package:get/get.dart';
import '../../parish/controllers/paroisse_controller.dart';
import '../../parish/controllers/pastor_controller.dart';
import '../controllers/reservation_controller.dart';

class MassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParoisseController>(() => ParoisseController());
    Get.lazyPut<PastorController>(() => PastorController());
    Get.lazyPut<ReservationController>(() => ReservationController());
  }
}
