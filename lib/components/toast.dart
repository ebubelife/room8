import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showToast(String label) {
  Get.snackbar(
    "",
    label,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Color.fromARGB(255, 199, 199, 199).withOpacity(0.4),
    borderRadius: 16,
    isDismissible: true,
    margin: const EdgeInsets.all(20),
    colorText: Color.fromARGB(255, 48, 48, 48),
    snackStyle: SnackStyle.FLOATING,
    duration: const Duration(seconds: 4),
  );
}
