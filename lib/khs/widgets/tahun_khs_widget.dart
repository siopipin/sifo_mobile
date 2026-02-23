import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_khs_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_info_tahun_ajaran_aktif_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class TahunKhsWidget extends StatelessWidget {
  const TahunKhsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TahunKhsProvider>(
      builder: (_, prov, __) {
        switch (prov.stateTahunKhs) {
          case StateTahunKhs.error:
            return const SizedBox.shrink();
          case StateTahunKhs.loading:
            return loading.shimmerCustom(height: 70);
          case StateTahunKhs.loaded:
            final list = prov.dataTahunKhs.data ?? [];
            if (list.isEmpty) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tahun Ajaran',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const KhsInfoTahunAjaranAktifWidget(),
                  if (list.length > 1) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: prov.tahun.isEmpty ? null : prov.tahun,
                      isExpanded: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: config.colorGrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text('Pilih tahun ajaran lainnya'),
                      items: list
                          .map((e) => DropdownMenuItem<String>(
                                value: e.tahunid?.toString() ?? '',
                                child: Text(
                                  e.tahunid ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null && val.isNotEmpty) {
                          _onTahunChanged(context, val);
                        }
                      },
                    ),
                  ],
                ],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _onTahunChanged(BuildContext context, String tahunid) async {
    final tahunProv = context.read<TahunKhsProvider>();
    final statusProv = context.read<StatusKhsProvider>();

    await statusProv.initial(tahunid: tahunid);

    if (statusProv.stateStatusKhs == StateStatusKhs.loaded &&
        statusProv.dataStatusKrs.status == true) {
      final khsid = statusProv.dataStatusKrs.data?.kHSID?.toString();
      if (khsid != null) {
        await context.read<KrsMhsProvider>().initial(khsid: khsid);
      }
    } else {
      statusProv.setStateStatusKhs = StateStatusKhs.nulldata;
    }
    tahunProv.setTahun = tahunid;
  }
}
