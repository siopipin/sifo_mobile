import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:http/http.dart' show Client, Response;

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  String globalFCMToken;
  String tokenFCM;
  Client client = Client();
  Response response;

  void setUpFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners(context);
  }

  void firebaseCloudMessagingListeners(BuildContext context) async {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) async {
      print('Token: $token');
      tokenFCM = await store.tokenFCM();
      if (tokenFCM != null) {
        await store.saveTokenFCM(val: token);
      } else if (tokenFCM != token) {
        await store.saveTokenFCM(val: token);
        await updateTokenMhs(fcm: token);
      } else {
        print('another condition');
      }
    });

    _firebaseMessaging.subscribeToTopic('global');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch');
      },
    );
  }

  _floatingNotification(Map<String, dynamic> message, BuildContext context) {
    List<dynamic> tmp = json.decode(message['data']['datas']);
    var judul = '';
    if (message['notification']['title'] == 'null' ||
        message['notification']['title'].toString().isEmpty) {
      judul = 'New Message';
    } else {
      judul = message['notification']['title'];
    }

    if (tmp[5] == "CHAT") {
      /// FlushBar
      return Flushbar(
        title: judul,
        message: "${message['notification']['body']}",
        duration: Duration(seconds: 5),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          Icons.message,
          size: 28.0,
          color: Colors.green[300],
        ),
        mainButton: FlatButton(
          onPressed: () {
            _navigateToItemDetail(message, context, 'onClick');
          },
          child: Text(
            "Open",
            style: TextStyle(color: Colors.amber),
          ),
        ),
        leftBarIndicatorColor: Colors.green[0],
      )..show(context);
    } else {
      /// FlushBar
      return Flushbar(
        title: "${message['notification']['title']}",
        message: "${message['notification']['body']}",
        duration: Duration(seconds: 3),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          Icons.work,
          size: 28.0,
          color: Colors.yellow[300],
        ),
        mainButton: FlatButton(
          onPressed: () {
            _navigateToItemDetail(message, context, 'onClick');
          },
          child: Text(
            "Oke",
            style: TextStyle(color: Colors.amber),
          ),
        ),
        leftBarIndicatorColor: Colors.yellow[300],
      )..show(context);
    }
  }

  void _navigateToItemDetail(
      Map<String, dynamic> message, BuildContext context, String m) async {
    print('$m $message');
    List<dynamic> tmp = json.decode(message['data']['datas']);
    if (tmp[5] == "CHAT") {
      // await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ChatPrivate(
      //               idOrder: "${tmp[0]}",
      //               customer: "${tmp[1]}",
      //               idOrderString: "${tmp[2]}",
      //               pasien: "${tmp[3]}",
      //             )));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        //  return ProductProgressUI(
        //       idordertring: "${tmp[1]}",
        //       namacustomer: "${tmp[3]}",
        //       pasien: "${tmp[4]}",
        //       idProduk: "${tmp[2]}",
        //       idOrder: "${tmp[0]}",
        //     )
      }));
    }
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future<bool> updateTokenMhs({@required String fcm}) async {
    var data = json.encode({"token": fcm});
    var token = await store.token();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };

    response = await client.put('$api/mahasiswa/token-update',
        headers: headerJwt, body: data);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
