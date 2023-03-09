import 'package:busrm/views/screen/home_screen.dart';
import 'package:busrm/views/screen/temp.dart';
import 'package:get/get.dart';

class introScreenController extends GetxController {
  @override
  void onInit() {
    loadIntro();
    super.onInit();
  }

  loadIntro() async {
    await Future.delayed(Duration(seconds: 5));
    Get.off(() => homeScreen()
    );
  }
}
