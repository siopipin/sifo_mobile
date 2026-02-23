import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_detail_provider.dart';
import 'package:sisfo_mobile/keuangan/models/keuangan_detail_model.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KeuanganDetailWidget extends StatelessWidget {
  const KeuanganDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<KeuanganDetailProvider>();

    return RefreshIndicator(
      onRefresh: () => prov.fetchKeuanganDetail(),
      child: ListView(
        children: [
          const KhsHeaderWidget(),
          if (prov.stateKeuanganDetail == StateKeuanganDetail.error)
            MessageWidget(
              info: 'Gagal memuat data. Tarik ke bawah untuk memuat ulang.',
              status: InfoWidgetStatus.warning,
              needBorderRadius: false,
            )
          else if (prov.stateKeuanganDetail == StateKeuanganDetail.loading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: config.padding),
              child: Column(
                children: [
                  SizedBox(height: config.padding),
                  loading.shimmerCustom(height: 72),
                  SizedBox(height: config.padding / 2),
                  loading.shimmerCustom(height: 72),
                  loading.shimmerCustom(height: 72),
                  loading.shimmerCustom(height: 72),
                ],
              ),
            )
          else if (prov.stateKeuanganDetail == StateKeuanganDetail.loaded)
            prov.dataKeuanganDetail.data!.isEmpty
                ? MessageWidget(
                    info: 'Belum ada riwayat pembayaran',
                    status: InfoWidgetStatus.warning,
                    needBorderRadius: false,
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Riwayat Pembayaran',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        ...prov.dataKeuanganDetail.data!
                            .map((item) => _PembayaranCard(item: item)),
                      ],
                    ),
                  )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _PembayaranCard extends StatelessWidget {
  final Data item;

  const _PembayaranCard({required this.item});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dt = DateTime.tryParse(dateStr);
      if (dt == null) return dateStr;
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaPembayaran ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(item.tanggal),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            config.rpFormat.format(item.jumlah ?? 0),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: config.colorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
