import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';

class KhsInfoTahunAjaranAktifWidget extends StatelessWidget {
  const KhsInfoTahunAjaranAktifWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<TahunAjaranAktifProvider, StatusKhsProvider>(
      builder: (_, tahunProv, statusProv, __) {
        final namaTA = tahunProv.dataTahunAjaranAktif.data?.namaTA ?? '-';
        final statusKrs = statusProv.dataStatusKrs.data?.statuskrs ?? '-';

        return Row(
          children: [
            Expanded(
              child: _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: 'TA Aktif',
                value: namaTA,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoChip(
                icon: Icons.verified_user_rounded,
                label: 'Status KRS',
                value: statusKrs,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
