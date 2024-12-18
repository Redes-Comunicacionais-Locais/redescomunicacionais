import 'package:get/get.dart';
import 'package:redescomunicacionais/app/ui/components/custom_alert_dialog.dart';
import 'package:redescomunicacionais/app/ui/components/uri_launcher_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageController extends GetxController {

    void goDocPage() {
    /* Get.toNamed(Routes.WEB_VIEW, arguments: {
      'url': '',
      'title': 'services'.tr,
    });*/
    customAlertDialog(Get.context!, title: 'page_under_development'.tr).show();
  }
  // final _obj = ''.obs;
  // set obj(value) => _obj.value = value;
  // get obj => _obj.value;
  String url = Get.arguments['url'];
  String title = Get.arguments['title'];
  bool interrogation = Get.arguments['interrogation']?? false;
  WebViewController wvc = WebViewController();

  @override
  void onInit() {
    wvc..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse(url));
    super.onInit();
  }
  
  void closeWebView(){
    customCloseWebView();
  }
}