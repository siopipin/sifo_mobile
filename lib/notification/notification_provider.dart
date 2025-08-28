import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:sisfo_mobile/notification/inbox_model.dart';
import 'package:sisfo_mobile/notification/notification_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class NotificationProvider extends ChangeNotifier {
  Client client = Client();

  String _msg = '';
  String get isMessage => _msg;
  set setMessage(val) {
    _msg = val;
    notifyListeners();
  }

  //Ambil Notification
  bool _loadingNotification = false;
  bool get isLoadingNotification => _loadingNotification;
  set setLoadingNotification(val) {
    _loadingNotification = val;
    notifyListeners();
  }

  bool _errorNotification = false;
  bool get isErrorNotification => _errorNotification;
  set setErrorNotification(val) {
    _errorNotification = val;
    notifyListeners();
  }

  bool _adaDataNotification = false;
  bool get isAdaDataNotification => _adaDataNotification;
  set setAdaDataNotification(val) {
    _adaDataNotification = val;
    notifyListeners();
  }

  NotificationModel? _notificationModel;
  NotificationModel get dataNotification => _notificationModel!;
  set setDataNotification(val) {
    _notificationModel = val;
    notifyListeners();
  }

  doGetNotification() async {
    setLoadingNotification = true;
    final response = await getNotification();
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataNotification = NotificationModel.fromJson(tmp);
        setAdaDataNotification = true;
        setMessage = 'Data ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataNotification = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 404) {
        setAdaDataNotification = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorNotification = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorNotification = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getNotification() async {
    var token = await store.showToken();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.get(
          Uri.parse('${config.api}/notification/notification'),
          headers: header);
      print(response.statusCode);
      setLoadingNotification = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingNotification = false;
      setErrorNotification = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Inbox
  bool _loadingInbox = false;
  bool get isLoadingInbox => _loadingInbox;
  set setLoadingInbox(val) {
    _loadingNotification = val;
    notifyListeners();
  }

  bool _errorInbox = false;
  bool get isErrorInbox => _errorInbox;
  set setErrorInbox(val) {
    _errorInbox = val;
    notifyListeners();
  }

  bool _adaDataInbox = false;
  bool get isAdaDataInbox => _adaDataInbox;
  set setAdaDataInbox(val) {
    _adaDataInbox = val;
    notifyListeners();
  }

  InboxModel? _inboxModel;
  InboxModel get dataInbox => _inboxModel!;
  set setDataInbox(val) {
    _inboxModel = val;
    notifyListeners();
  }

  doGetInbox() async {
    setLoadingInbox = true;
    final response = await getInbox();
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataInbox = InboxModel.fromJson(tmp);
        setAdaDataInbox = true;
        setMessage = 'Data ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataInbox = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 404) {
        setAdaDataInbox = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorInbox = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorInbox = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getInbox() async {
    var token = await store.showToken();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.get(
          Uri.parse('${config.api}/notification/notification-mhs'),
          headers: header);
      print(response.statusCode);
      setLoadingInbox = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingInbox = false;
      setErrorInbox = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Inbox
  bool _loadingInboxUpdate = false;
  bool get isLoadingInboxUpdate => _loadingInboxUpdate;
  set setLoadingInboxUpdate(val) {
    _loadingNotification = val;
    notifyListeners();
  }

  bool _errorInboxUpdate = false;
  bool get isErrorInboxUpdate => _errorInboxUpdate;
  set setErrorInboxUpdate(val) {
    _errorInboxUpdate = val;
    notifyListeners();
  }

  bool _adaDataInboxUpdate = false;
  bool get isAdaDataInboxUpdate => _adaDataInboxUpdate;
  set setAdaDataInboxUpdate(val) {
    _adaDataInboxUpdate = val;
    notifyListeners();
  }

  doGetInboxUpdate({required int id}) async {
    setLoadingInboxUpdate = true;
    final response = await getInboxUpdate(id: id);
    if (response != null) {
      if (response.statusCode == 200) {
        setAdaDataInboxUpdate = true;
        setMessage = 'Data ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataInboxUpdate = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorInboxUpdate = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorInboxUpdate = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getInboxUpdate({required int id}) async {
    DateTime tgl = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(tgl);

    var data = json.encode({'notificationid': id, 'tgl': formatted});
    var token = await store.showToken();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.put(
          Uri.parse('${config.api}/notification/notification-mhs-update'),
          headers: header,
          body: data);
      print(response.statusCode);
      setLoadingInboxUpdate = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingInboxUpdate = false;
      setErrorInboxUpdate = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }
}
