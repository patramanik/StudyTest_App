import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/theme/global_screen_size.dart';

Widget serviceCard(String title, Color color,IconData icon) {
  String currentSize = getCurrentScreen(screenSize: Get.width);

  double cardWidth = currentSize == 'xsmall'
      ? Get.width * 0.4
      : currentSize == 'small'
      ? Get.width * 0.4
      : currentSize == 'medium'
      ? Get.width * 0.4
      : Get.width * 0.4;

  double cardHeight = currentSize == 'xsmall'
      ? Get.height * 0.1
      : currentSize == 'small'
      ? Get.height * 0.2
      : currentSize == 'medium'
      ? Get.height * 0.3
      : Get.height * 0.3;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    child: Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: currentSize == 'xsmall'
                ? 25
                : currentSize == 'small'
                ? 30
                : currentSize == 'medium'
                ? 36
                : 40,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: currentSize == 'xsmall'
                  ? 17
                  : currentSize == 'small'
                  ? 18
                  : currentSize == 'medium'
                  ? 20
                  : 22,
            ),
          ),
        ],
      ),
    ),
  );
}
