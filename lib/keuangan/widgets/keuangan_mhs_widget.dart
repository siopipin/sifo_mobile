import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_provider.dart';
import 'package:sisfo_mobile/keuangan/models/keuangan_mhs_model.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';

class KeuanganMhsWidget extends StatelessWidget {
  const KeuanganMhsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<KeuanganMhsProvider>();

    return RefreshIndicator(
      onRefresh: () => prov.fetchKeuanganMhs(),
      child: ListView(
        children: [
          const KhsHeaderWidget(),
          if (prov.stateKeuanganMhs == StateKeuanganMhs.error)
            MessageWidget(
              info: 'Gagal memuat data. Tarik ke bawah untuk memuat ulang.',
              status: InfoWidgetStatus.warning,
              needBorderRadius: false,
            )
          else if (prov.stateKeuanganMhs == StateKeuanganMhs.loading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: CircularProgressIndicator(color: config.colorPrimary),
              ),
            )
          else if (prov.stateKeuanganMhs == StateKeuanganMhs.loaded)
            prov.dataKeuanganMhs.data!.isEmpty
                ? MessageWidget(
                    info: 'Belum ada tagihan',
                    status: InfoWidgetStatus.warning,
                    needBorderRadius: false,
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      children: prov.dataKeuanganMhs.data!
                          .map((item) => _TagihanCard(item: item))
                          .toList(),
                    ),
                  )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _TagihanCard extends StatelessWidget {
  final Data item;

  const _TagihanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final tunggakan = item.tunggakan is int
        ? (item.tunggakan as int)
        : int.tryParse(item.tunggakan?.toString() ?? '0') ?? 0;
    final hasTunggakan = tunggakan > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (hasTunggakan
                          ? config.colorPrimary
                          : Colors.green)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  hasTunggakan ? Icons.pending_actions : Icons.check_circle,
                  color: hasTunggakan ? config.colorPrimary : Colors.green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.namaTagihan ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Th. ${item.tahunid ?? '-'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                config.rpFormat.format(tunggakan),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: hasTunggakan ? config.colorPrimary : Colors.green,
                ),
              ),
            ],
          ),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 12),
            _InfoRow(label: 'Jumlah', value: config.rpFormat.format(item.jumlah ?? 0)),
            const SizedBox(height: 8),
            _InfoRow(label: 'Terbayar', value: config.rpFormat.format(item.terbayar ?? 0)),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Tunggakan',
              value: config.rpFormat.format(tunggakan),
              valueBold: true,
              valueColor: hasTunggakan ? config.colorPrimary : Colors.green,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: item.kodeVA ?? ''));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('VA berhasil disalin'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: config.colorGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance, color: config.colorPrimary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Virtual Account',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            item.kodeVA ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.copy, size: 20, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
