import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/nilai/nilai_model.dart';
import 'package:sisfo_mobile/nilai/nilai_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/error_widget.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';

class NilaiScreen extends StatefulWidget {
  final bool needAppbar;
  const NilaiScreen({Key? key, this.needAppbar = true}) : super(key: key);

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NilaiProvider>().initial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.needAppbar
          ? AppBar(
              backgroundColor: config.colorPrimary,
              title: const Text('Nilai'),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<NilaiProvider>().doGetTahunKHS(),
              child: ListView(
                children: [
                  const KhsHeaderWidget(),
                  _buildBody(),
                ],
              ),
            ),
          ),
          _TahunDropdown(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<NilaiProvider>(
      builder: (_, prov, __) {
        if (prov.isLoading && !prov.isData) {
          return _buildLoading();
        }
        if (prov.isError && !prov.isData) {
          return _buildError(prov);
        }
        if (prov.isLoadingNilai && !prov.isDataNilai) {
          return _buildLoading();
        }
        if (prov.isErrorNilai) {
          return _buildErrorNilai(prov);
        }
        if (prov.isDataNilai && prov.dataNilai.data != null) {
          return prov.dataNilai.data!.isEmpty
              ? MessageWidget(
                  info: 'Belum ada data nilai',
                  status: InfoWidgetStatus.warning,
                  needBorderRadius: false,
                )
              : _NilaiList(data: prov.dataNilai.data!, provider: prov);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: CircularProgressIndicator(color: config.colorPrimary),
      ),
    );
  }

  Widget _buildError(NilaiProvider prov) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SomeError(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => prov.doGetTahunKHS(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorNilai(NilaiProvider prov) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          MessageWidget(
            info: prov.isMsg,
            status: InfoWidgetStatus.warning,
            needBorderRadius: false,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => prov.doGetNilai(tahun: prov.isTahun),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _TahunDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NilaiProvider>(
      builder: (_, prov, __) {
        if (prov.isLoading && !prov.isData) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(color: config.colorPrimary),
              ),
            ),
          );
        }
        if (!prov.isData || prov.dataTahunKHS.data == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: prov.dataTahunKHS.data!.any((e) => e.tahunid == prov.isTahun)
                ? prov.isTahun
                : prov.dataTahunKHS.data!.first.tahunid,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: config.colorGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: prov.dataTahunKHS.data!
                .map((e) => DropdownMenuItem(
                      value: e.tahunid,
                      child: Row(
                        children: [
                          Icon(LineIcons.calendar,
                              size: 20, color: config.colorPrimary),
                          const SizedBox(width: 12),
                          Text(
                            'Tahun ${e.tahunid ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (val) async {
              if (val == null) return;
              await prov.doGetNilai(tahun: val);
              Fluttertoast.showToast(msg: prov.isMsg);
            },
          ),
        );
      },
    );
  }
}

class _NilaiList extends StatelessWidget {
  final List<Data> data;
  final NilaiProvider provider;

  const _NilaiList({required this.data, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Daftar Mata Kuliah',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ...List.generate(data.length,
              (i) => _NilaiCard(item: data[i], index: i, provider: provider)),
        ],
      ),
    );
  }
}

class _NilaiCard extends StatelessWidget {
  final Data item;
  final int index;
  final NilaiProvider provider;

  const _NilaiCard(
      {required this.item, required this.index, required this.provider});

  String _parseNilai(dynamic v) {
    if (v == null) return '-';
    if (v is num) return v.toStringAsFixed(v is double ? 2 : 0);
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          onExpansionChanged: (v) => provider.setExpanded(index, v),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: config.colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(Icons.menu_book, color: config.colorPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.nama ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.mKKode ?? '-'} • ${item.sKS ?? 0} SKS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: config.colorPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _parseNilai(item.nilaiAkhir),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: config.colorPrimary,
                  ),
                ),
              ),
            ],
          ),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 12),
            _DetailRow('Tugas 1', _parseNilai(item.tugas1)),
            _DetailRow('Tugas 2', _parseNilai(item.tugas2)),
            _DetailRow('Tugas 3', _parseNilai(item.tugas3)),
            _DetailRow('Jumlah Absensi', _parseNilai(item.vPresensi)),
            _DetailRow('Nilai Absensi', _parseNilai(item.nPresensi)),
            _DetailRow('UTS', _parseNilai(item.uTS)),
            _DetailRow('UAS', _parseNilai(item.uAS)),
            _DetailRow('Nilai Akhir', _parseNilai(item.nilaiAkhir),
                isBold: true),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
