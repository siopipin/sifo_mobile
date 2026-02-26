import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';
import 'package:sisfo_mobile/profile/widgets/foto_profile_widget.dart';
import 'package:sisfo_mobile/profile/widgets/text_button_simpan.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/button_custom.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/auth/login_screen.dart';

class ProfileMhsScreen extends StatefulWidget {
  final bool needAppbar;
  const ProfileMhsScreen({Key? key, this.needAppbar = true}) : super(key: key);

  @override
  State<ProfileMhsScreen> createState() => _ProfileMhsScreenState();
}

class _ProfileMhsScreenState extends State<ProfileMhsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileMhsProvider>().initial();
      context.read<HomeProvider>().getDataAwal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.needAppbar
          ? AppBar(
              backgroundColor: config.colorPrimary,
              title: const Text('Profile'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => context.read<ProfileMhsProvider>().refresh(),
        child: ListView(
          children: [
            FotoProfileWidget(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<ProfileMhsProvider>(
      builder: (_, prov, __) {
        if (prov.stateProfileMhs == StateProfileMhs.loading) {
          return _buildLoading();
        }
        if (prov.stateProfileMhs == StateProfileMhs.nulldata) {
          return MessageWidget(
            info: 'Profile tidak ditemukan',
            status: InfoWidgetStatus.warning,
            needBorderRadius: false,
          );
        }
        if (prov.stateProfileMhs == StateProfileMhs.loaded &&
            prov.dataProfileMhs.data != null) {
          return _ProfileDetailContent(data: prov.dataProfileMhs.data!);
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
}

class _ProfileDetailContent extends StatelessWidget {
  final dynamic data;

  const _ProfileDetailContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _DetailProfileSectionHeader(),
          const SizedBox(height: 12),
          _ProfileCard(
            children: [
              _ProfileDetailRow(
                  ket: 'Alamat',
                  data: data.alamat,
                  editable: true,
                  textKey: 'alamat'),
              _ProfileDetailRow(
                  ket: 'Email',
                  data: data.email,
                  editable: true,
                  textKey: 'email'),
              _ProfileDetailRow(
                  ket: 'Handphone',
                  data: data.handphone,
                  editable: true,
                  textKey: 'hp'),
              _ProfileDetailRow(
                  ket: 'Handphone Orang Tua',
                  data: data.handphoneOrtu,
                  editable: true,
                  textKey: 'hpOrtu'),
              _ProfileDetailRow(ket: 'KTP', data: data.kTP, editable: false),
              _ProfileDetailRow(
                  ket: 'Tanggal Lahir',
                  data: data.tanggalLahir,
                  editable: false),
              _ProfileDetailRow(
                  ket: 'Agama', data: data.agama, editable: false),
              _ProfileDetailRow(
                  ket: 'Nama Ibu', data: data.namaIbu, editable: false),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Kelas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _ProfileCard(
            children: [
              _ProfileDetailRow(
                  ket: 'Nama Kelas', data: data.namaKelas, editable: false),
              _ProfileDetailRow(
                  ket: 'Mentor - PA', data: data.pA, editable: false),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DetailProfileSectionHeader extends StatelessWidget {
  const _DetailProfileSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileMhsProvider>(
      builder: (_, prov, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Detail Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            prov.isEdit
                ? const TextButtonSimpan()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        onPressed: () => prov.setEdit = true,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit'),
                      ),
                      TextButton.icon(
                        onPressed: () => _showGantiPasswordDialog(context),
                        icon: const Icon(Icons.lock_outline, size: 18),
                        label: const Text('Ganti Password'),
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }

  void _showGantiPasswordDialog(BuildContext context) {
    final prov = context.read<ProfileMhsProvider>();
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final reNewCtrl = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureReNew = true;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Ganti Kata Sandi'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Untuk keamanan akun, masukkan kata sandi lama dan buat kata sandi baru.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: oldCtrl,
                  obscureText: obscureOld,
                  decoration: InputDecoration(
                    labelText: 'Kata sandi lama',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureOld ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setStateDialog(() {
                          obscureOld = !obscureOld;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: config.colorPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newCtrl,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'Kata sandi baru',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setStateDialog(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: config.colorPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reNewCtrl,
                  obscureText: obscureReNew,
                  decoration: InputDecoration(
                    labelText: 'Ulangi kata sandi baru',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureReNew ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setStateDialog(() {
                          obscureReNew = !obscureReNew;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: config.colorPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ButtonCustom(
                  function: () async {
                    final oldPass = oldCtrl.text.trim();
                    final newPass = newCtrl.text.trim();
                    final reNewPass = reNewCtrl.text.trim();

                    if (oldPass.isEmpty ||
                        newPass.isEmpty ||
                        reNewPass.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Semua kolom kata sandi wajib diisi');
                      return;
                    }
                    if (newPass.length < 6) {
                      Fluttertoast.showToast(
                          msg: 'Kata sandi baru minimal 6 karakter');
                      return;
                    }
                    if (newPass != reNewPass) {
                      Fluttertoast.showToast(
                          msg: 'Kata sandi baru dan ulangi tidak sama');
                      return;
                    }

                    final ok = await prov.changePassword(
                      oldPassword: oldPass,
                      newPassword: newPass,
                    );

                    if (!ctx.mounted) return;
                    if (ok) {
                      Navigator.pop(ctx);
                      Fluttertoast.showToast(
                          msg:
                              'Kata sandi berhasil diganti, silakan login ulang');
                      await store.removeLoginData();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  text: 'Simpan',
                  color: config.colorPrimary,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileCard({required this.children});

  @override
  Widget build(BuildContext context) {
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
        children: children,
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final String ket;
  final dynamic data;
  final bool editable;
  final String? textKey;

  const _ProfileDetailRow({
    required this.ket,
    required this.data,
    required this.editable,
    this.textKey,
  });

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProfileMhsProvider>();
    final value = data?.toString() ?? '-';
    final isEdit = prov.isEdit && editable;

    TextEditingController? ctrl;
    if (textKey != null) {
      switch (textKey) {
        case 'alamat':
          ctrl = prov.ctrlAlamat;
          break;
        case 'email':
          ctrl = prov.ctrlEmail;
          break;
        case 'hp':
          ctrl = prov.ctrlHP;
          break;
        case 'hpOrtu':
          ctrl = prov.ctrlHPOrtu;
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              ket,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: isEdit && ctrl != null
                ? TextField(
                    controller: ctrl,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: config.colorGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Tidak boleh kosong',
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
