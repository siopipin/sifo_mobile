import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/storage.dart';

class InitialProvider extends ChangeNotifier {
  initial() {
    setInitialPage = 'SPLASH';
    cekInitialPage();
  }

  String initialPage = 'SPLASH';
  String get getInitialPage => initialPage;
  set setInitialPage(val) {
    initialPage = val;
    notifyListeners();
  }

  cekInitialPage() async {
    dynamic splash = await store.showSplash();
    dynamic token = await store.showToken();

    if (splash == null) {
      setInitialPage = 'SPLASH';
    } else if (splash != null && token == null) {
      setInitialPage = 'LOGIN';
    } else {
      setInitialPage = 'HOME';
    }
  }
}
