import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  final Widget? resetButton;

  const ErrorScreen({super.key, required this.errorDetails, this.resetButton});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_ErrorController>(
        init: _ErrorController(errorDetails: errorDetails),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(Icons.warning_rounded, size: 200, color: Colors.orange).paddingOnly(bottom: 20),
                  Text(
                    kDebugMode ? errorDetails.summary.toString() : 'Vaya, algo salió mal',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                  ).paddingOnly(bottom: 20),
                  const Text(
                    "Se ha producido un error y se ha informado al equipo de desarrollo. Sentimos los inconvenientes causados.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ).paddingOnly(bottom: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (resetButton != null) resetButton!,
                      FilledButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Volver")),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class _ErrorController extends GetxController {
  final FlutterErrorDetails errorDetails;

  _ErrorController({required this.errorDetails});

  @override
  void onInit() async {
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    FirebaseFirestore.instance.collection("crash").add({
      'summary': errorDetails.summary.toString(),
      'debug': kDebugMode,
      'platform': {'ios': Platform.isIOS, 'android': Platform.isAndroid, 'web': kIsWeb},
      'library': errorDetails.library,
      'exception': errorDetails.exception.toString(),
      'stacktrace': errorDetails.stack?.toString(),
      'app': {
        'appname': packageInfo.appName,
        'package': packageInfo.packageName,
        'version': packageInfo.version,
        'build': packageInfo.buildNumber,
        'signature': packageInfo.buildSignature
      },
      'when': DateTime.now(),
    });
  }
}
