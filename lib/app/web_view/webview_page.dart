import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/web_view/webview_controller.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebViewPageController>(
      init: WebViewPageController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: ( ) => onExit(controller),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () async {
                    if (await controller.wvc.canGoBack()) {
                      controller.wvc.goBack();
                    } else {
                      Get.back();
                    }
                  }, icon: const Icon(Icons.arrow_back)),
                  Expanded(child: Center(child: Text(controller.title))),
                  IconButton(onPressed: () {Get.back();}, icon: const Icon(Icons.close)),                  
                  controller.interrogation? IconButton(onPressed: (){controller.goDocPage();}, icon: const Icon(Icons.question_mark, color: Colors.white,)) : const SizedBox(width: 0,),
                ],
              ),
            ),
            body: WebViewWidget(controller: controller.wvc,),
          ),
        );
      });
  }

  Future<bool> onExit(WebViewPageController controller) async {
    if (await controller.wvc.canGoBack()) {
      controller.wvc.goBack();
      return Future.value(false);
    }
    return Future.value(true);
  }
}
