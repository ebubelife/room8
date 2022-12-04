import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

dynamic loading2(String label, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => Center(
      child: Material(
        color: Colors.black.withOpacity(.2),
        child: Center(
          child: LoadingAnimationWidget.flickr(
            leftDotColor: Color.fromARGB(255, 219, 36, 4),
            rightDotColor: Color.fromARGB(255, 236, 112, 11),
            size: 80,
          ),
        ),
      ),
    ),
  );
}

dynamic loading3(String label, bool visibility) {
  Get.dialog(
    Material(
        color: Colors.black.withOpacity(.2),
        child: Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibility,
          child: Center(
            child: Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(label, textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        )),
  );
}

Widget loader() {
  return Center(
      child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //color: Colors.white,
          ),
          child: Center(
            child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromARGB(255, 236, 112, 11)),
                )),
          )));
}
