import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/notification/notification_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/error_widget.dart';
import 'package:sisfo_mobile/widgets/loading.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      Provider.of<NotificationProvider>(context, listen: false).doGetInbox();
      Provider.of<NotificationProvider>(context, listen: false)
          .doGetNotification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appbarColor,
            title: Text('Keuangan'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.inbox),
                  text: 'Inbox',
                ),
                Tab(icon: Icon(Icons.notifications), text: 'Notifikasi'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    cekInbox()
                  ],
                ),
              )),
              SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    cekNotification()
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  Widget cekInbox() {
    final NotificationProvider prov =
        Provider.of<NotificationProvider>(context);

    if (prov.isLoadingInbox) {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: List.generate(3, (index) => loadingList),
        ),
      );
    } else if (prov.isErrorInbox) {
      return SomeError();
    } else if (!prov.isAdaDataInbox) {
      return Container(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              LineIcons.bookmark,
              size: 40,
            ),
            Text(
              'Inbox kosong.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      );
    } else if (prov.isAdaDataInbox) {
      return Column(
        children: prov.dataInbox.data.map((e) {
          return Column(
            children: [
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Stack(alignment: Alignment.centerLeft, children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: textPrimary, shape: BoxShape.circle),
                          child: Center(
                            child: Icon(LineIcons.inbox,
                                color: Colors.white, size: 15),
                          ),
                        ),
                        e.status == 0
                            ? Positioned(
                                // draw a red marble
                                top: 5,
                                right: 6,
                                child: new Icon(Icons.brightness_1,
                                    size: 8.0, color: Colors.redAccent),
                              )
                            : Container()
                      ]),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              e.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              e.tanggalKirim,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 10),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(e.isi,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                onTap: () => _modalBottomSheetMenu(
                    status: e.status,
                    id: e.id,
                    isi: e.isi,
                    title: e.title,
                    tgl: e.tanggalKirim),
              ),
              Divider()
            ],
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }

  Widget cekNotification() {
    final NotificationProvider prov =
        Provider.of<NotificationProvider>(context);

    if (prov.isLoadingNotification) {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: List.generate(3, (index) => loadingList),
        ),
      );
    } else if (prov.isErrorNotification) {
      return SomeError();
    } else if (!prov.isAdaDataNotification) {
      return Container(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              LineIcons.bookmark,
              size: 40,
            ),
            Text(
              'Inbox kosong.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      );
    } else if (prov.isAdaDataNotification) {
      return Column(
        children: prov.dataNotification.data.map((e) {
          return Column(
            children: [
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Stack(alignment: Alignment.centerLeft, children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: textPrimary, shape: BoxShape.circle),
                          child: Center(
                            child: Icon(LineIcons.inbox,
                                color: Colors.white, size: 15),
                          ),
                        ),
                        e.status == 0
                            ? Positioned(
                                // draw a red marble
                                top: 5,
                                right: 6,
                                child: new Icon(Icons.brightness_1,
                                    size: 8.0, color: Colors.redAccent),
                              )
                            : Container()
                      ]),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              e.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              e.tanggalKirim,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 10),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(e.isi,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                onTap: () => _modalBottomSheetMenuNotif(
                    id: e.id, isi: e.isi, title: e.title, tgl: e.tanggalKirim),
              ),
              Divider()
            ],
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }

  void _modalBottomSheetMenu(
      {@required int id,
      @required String isi,
      @required int status,
      @required String title,
      @required String tgl}) {
    final NotificationProvider prov =
        Provider.of<NotificationProvider>(context, listen: false);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        isDismissible: false,
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(tgl,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 12)),
                            ],
                          ),
                          GestureDetector(
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: Icon(LineIcons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              if (status == 0) {
                                await prov.doGetInboxUpdate(id: id);
                                if (prov.isAdaDataInboxUpdate) {
                                  await prov.doGetInbox();
                                } else {
                                  print('gagal update');
                                }
                              } else {
                                print('sudah pernah dibaca');
                              }
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        isi,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.grey[800], fontSize: 12),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  void _modalBottomSheetMenuNotif(
      {@required int id,
      @required String isi,
      @required String title,
      @required String tgl}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(tgl,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 12)),
                            ],
                          ),
                          GestureDetector(
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: Icon(LineIcons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        isi,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.grey[800], fontSize: 12),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
