import 'package:flutter/material.dart';
import 'package:sisfo_mobile/providers/storage.dart';

class HomeProvider extends ChangeNotifier {
  String name = '';

  String get isName => name;

  set setNama(val) {
    name = val;
    notifyListeners();
  }

  getNamaMahasiswa() async {
    String tmp = await store.nama();
    if (tmp != null) {
      setNama = tmp;
    } else {
      setNama = 'User';
    }
  }
}
