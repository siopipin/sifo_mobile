import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/notification/inbox_model.dart' as inbox;
import 'package:sisfo_mobile/notification/notification_model.dart' as notif;
import 'package:sisfo_mobile/notification/notification_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/error_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NotificationProvider>().doGetInbox();
      context.read<NotificationProvider>().doGetNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: config.colorPrimary,
          title: const Text('Notifikasi'),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.inbox_outlined), text: 'Inbox'),
              Tab(icon: Icon(Icons.notifications_outlined), text: 'Notifikasi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _InboxTab(),
            _NotificationTab(),
          ],
        ),
      ),
    );
  }
}

class _InboxTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<NotificationProvider>().doGetInbox(),
      child: _TabContent(
        isLoading:
            context.select<NotificationProvider, bool>((p) => p.isLoadingInbox),
        isError:
            context.select<NotificationProvider, bool>((p) => p.isErrorInbox),
        hasData:
            context.select<NotificationProvider, bool>((p) => p.isAdaDataInbox),
        emptyMessage: 'Inbox kosong',
        buildList: () {
          final data =
              context.read<NotificationProvider>().dataInbox.data ?? [];
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _InboxCard(item: data[i]),
          );
        },
      ),
    );
  }
}

class _NotificationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<NotificationProvider>().doGetNotification(),
      child: _TabContent(
        isLoading: context
            .select<NotificationProvider, bool>((p) => p.isLoadingNotification),
        isError: context
            .select<NotificationProvider, bool>((p) => p.isErrorNotification),
        hasData: context
            .select<NotificationProvider, bool>((p) => p.isAdaDataNotification),
        emptyMessage: 'Belum ada notifikasi',
        buildList: () {
          final data =
              context.read<NotificationProvider>().dataNotification.data ?? [];
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _NotificationCard(item: data[i]),
          );
        },
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final bool isLoading;
  final bool isError;
  final bool hasData;
  final String emptyMessage;
  final Widget Function() buildList;

  const _TabContent({
    required this.isLoading,
    required this.isError,
    required this.hasData,
    required this.emptyMessage,
    required this.buildList,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          loading.shimmerCustom(height: 90),
          const SizedBox(height: 12),
          loading.shimmerCustom(height: 90),
          const SizedBox(height: 12),
          loading.shimmerCustom(height: 90),
        ],
      );
    }
    if (isError) {
      return const Center(child: SomeError());
    }
    if (!hasData) {
      return _EmptyState(message: emptyMessage);
    }
    return buildList();
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InboxCard extends StatelessWidget {
  final inbox.Data item;

  const _InboxCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isUnread = (item.status ?? 1) == 0;

    return _NotificationCardBase(
      title: item.title ?? '-',
      date: item.tanggalKirim ?? '-',
      body: item.isi ?? '-',
      icon: Icons.mail_outline,
      iconColor: config.colorPrimary,
      isUnread: isUnread,
      onTap: () => _showDetail(
        context,
        title: item.title ?? '-',
        date: item.tanggalKirim ?? '-',
        body: item.isi ?? '-',
        isInbox: true,
        id: item.id,
        status: item.status ?? 1,
      ),
    );
  }

  void _showDetail(
    BuildContext context, {
    required String title,
    required String date,
    required String body,
    required bool isInbox,
    required int? id,
    required int status,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DetailSheet(
        title: title,
        date: date,
        body: body,
        onClose: () async {
          Navigator.pop(ctx);
          if (status == 0 && id != null) {
            final prov = context.read<NotificationProvider>();
            await prov.doGetInboxUpdate(id: id);
            if (prov.isAdaDataInboxUpdate) {
              await prov.doGetInbox();
            }
          }
        },
        showMarkRead: status == 0,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final notif.Data item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _NotificationCardBase(
      title: item.title ?? '-',
      date: item.tanggalKirim ?? '-',
      body: item.isi ?? '-',
      icon: Icons.notifications_outlined,
      iconColor: config.colorPrimary,
      isUnread: false,
      onTap: () => _showDetail(context),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DetailSheet(
        title: item.title ?? '-',
        date: item.tanggalKirim ?? '-',
        body: item.isi ?? '-',
        onClose: () => Navigator.pop(ctx),
        showMarkRead: false,
      ),
    );
  }
}

class _NotificationCardBase extends StatelessWidget {
  final String title;
  final String date;
  final String body;
  final IconData icon;
  final Color iconColor;
  final bool isUnread;
  final VoidCallback onTap;

  const _NotificationCardBase({
    required this.title,
    required this.date,
    required this.body,
    required this.icon,
    required this.iconColor,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  if (isUnread)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  final String title;
  final String date;
  final String body;
  final VoidCallback onClose;
  final bool showMarkRead;

  const _DetailSheet({
    required this.title,
    required this.date,
    required this.body,
    required this.onClose,
    this.showMarkRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text(
              body,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
