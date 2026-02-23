import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_khs_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_detail_widget.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/khs/widgets/tahun_khs_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KhsScreen extends StatefulWidget {
  final bool needAppbar;

  const KhsScreen({
    Key? key,
    this.needAppbar = true,
  }) : super(key: key);

  @override
  State<KhsScreen> createState() => _KhsScreenState();
}

class _KhsScreenState extends State<KhsScreen> {
  Future<void> _loadData() async {
    context.read<HomeProvider>().initial();
    await context.read<TahunKhsProvider>().initial();
    await context.read<TahunAjaranAktifProvider>().initial();

    final tahunProv = context.read<TahunAjaranAktifProvider>();
    if (tahunProv.stateTahunAjaranAktif != StateTahunAjaranAktif.loaded ||
        tahunProv.dataTahunAjaranAktif.status != true) {
      return;
    }

    final tahunTA = tahunProv.dataTahunAjaranAktif.data?.tahunTA;
    if (tahunTA == null) return;

    await context.read<StatusKhsProvider>().initial(tahunid: tahunTA);

    final statusProv = context.read<StatusKhsProvider>();
    if (statusProv.stateStatusKhs == StateStatusKhs.loaded &&
        statusProv.dataStatusKrs.status == true) {
      final khsid = statusProv.dataStatusKrs.data?.kHSID?.toString();
      if (khsid != null) {
        await context.read<KrsMhsProvider>().initial(khsid: khsid);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.needAppbar
          ? AppBar(
              backgroundColor: config.colorPrimary,
              title: const Text('Info KRS'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const KhsHeaderWidget(),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<TahunAjaranAktifProvider>(
      builder: (_, prov, __) {
        if (prov.stateTahunAjaranAktif == StateTahunAjaranAktif.loading) {
          return _buildLoading();
        }
        if (prov.stateTahunAjaranAktif == StateTahunAjaranAktif.nulldata) {
          return MessageWidget(
            info: 'Tahun ajaran aktif tidak ditemukan',
            status: InfoWidgetStatus.warning,
            needBorderRadius: false,
          );
        }
        if (prov.stateTahunAjaranAktif == StateTahunAjaranAktif.loaded) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                TahunKhsWidget(),
                SizedBox(height: 16),
                KhsDetailWidget(),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          loading.shimmerCustom(height: 50),
          const SizedBox(height: 8),
          loading.shimmerCustom(height: 50),
          const SizedBox(height: 16),
          loading.shimmerCustom(height: 120),
        ],
      ),
    );
  }
}
