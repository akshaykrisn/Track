import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:busrm/themes/themes.dart';
import 'package:busrm/controllers/intro_screen_controller.dart';

class introScreen extends StatelessWidget {

  var IntroScreenController = Get.put(introScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        color: bgColor,
        child: Center(
          child: Image.asset("assets/busrm logo 2.png",
              width: 240,
          ),
        ),
      ),
    );
  }
}
