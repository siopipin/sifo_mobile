import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/models/krs_mhs_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';

const _hariNames = {
  1: 'Senin',
  2: 'Selasa',
  3: 'Rabu',
  4: 'Kamis',
  5: 'Jumat',
  6: 'Sabtu',
};

class KHSJadwalWidget extends StatelessWidget {
  const KHSJadwalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<KrsMhsProvider>(
      builder: (_, prov, __) {
        final data = prov.dataKrsMhs.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var hari = 1; hari <= 6; hari++) ...[
              if (_hasHari(prov, hari)) _HariSection(hari: hari, data: data),
            ],
          ],
        );
      },
    );
  }

  bool _hasHari(KrsMhsProvider prov, int hari) {
    switch (hari) {
      case 1: return prov.isSenin;
      case 2: return prov.isSelasa;
      case 3: return prov.isRabu;
      case 4: return prov.isKamis;
      case 5: return prov.isJumat;
      case 6: return prov.isSabtu;
      default: return false;
    }
  }
}

class _HariSection extends StatelessWidget {
  final int hari;
  final List<Data> data;

  const _HariSection({required this.hari, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = data.where((e) => e.hariID == hari).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: config.colorSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _hariNames[hari] ?? '',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((e) => _MataKuliahCard(
                item: e.value,
                index: data.indexOf(e.value),
              )),
        ],
      ),
    );
  }
}

class _MataKuliahCard extends StatelessWidget {
  final Data item;
  final int index;

  const _MataKuliahCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<KrsMhsProvider>(
      builder: (_, prov, __) {
        final isExpanded = item.isExpanded ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
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
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (expanded) {
                prov.setExpanded(index, expanded);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mata Kuliah',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.nama ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.dSN ?? '-',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: config.colorGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _DetailRow(label: 'Kode', value: item.mKKode ?? '-'),
                      const SizedBox(height: 8),
                      _DetailRow(
                        label: 'Jam',
                        value: '${item.jM ?? '-'} - ${item.jS ?? '-'}',
                      ),
                      const SizedBox(height: 8),
                      _DetailRow(label: 'Ruang', value: item.ruangID ?? '-'),
                      const SizedBox(height: 8),
                      _DetailRow(label: 'SKS', value: '${item.sKS ?? '-'}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
