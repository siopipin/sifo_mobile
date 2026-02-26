import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Template KTM: foto di area lingkaran merah (sekitar 32% dari atas),
/// informasi nama, NPM, prodi, program, status di area bawah (dari ~52%).
class KtmScreen extends StatelessWidget {
  const KtmScreen({Key? key}) : super(key: key);

  static const String _ktmAsset = 'assets/images/ktm.png';

  /// Perkiraan rasio tinggi/lebar template (portrait).
  static const double _cardAspectRatio = 1.55;

  /// Posisi vertikal pusat lingkaran foto (0–1).
  static const double _photoCenterFraction = 0.53;

  /// Posisi horizontal pusat lingkaran foto (0–1). < 0.5 = ke kiri.
  static const double _photoCenterXFraction = 0.49;

  /// Radius foto relatif terhadap lebar kartu.
  static const double _photoRadiusFraction = 0.23;

  /// Mulai area teks dari atas (0–1).
  static const double _infoTopFraction = 0.76;

  /// Ukuran QR code (px) dan jarak di atas foto.
  static const double _qrSize = 86;

  /// Jarak antara QR dan lingkaran foto (px).
  static const double _qrGapAbovePhoto = 10;

  /// Geser QR vertikal: positif = ke bawah, negatif = ke atas (px).
  static const double _qrVerticalOffset = 28;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.colorPrimary,
        title: const Text('Kartu Tanda Mahasiswa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Consumer2<HomeProvider, ProfileMhsProvider>(
            builder: (_, home, profile, __) {
              final fotoUrl =
                  profile.stateProfileMhs == StateProfileMhs.loaded &&
                          profile.dataProfileMhs.data?.foto != null
                      ? '${config.imgurl}/${profile.dataProfileMhs.data!.foto}'
                      : null;
              final npm = home.isNIM.trim();
              final tanggalLahir = home.isTglLahir;

              final qrData = _buildQrData(npm, tanggalLahir);

              return LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = w * _cardAspectRatio;
                  final photoRadius = w * _photoRadiusFraction;
                  final photoTop = h * _photoCenterFraction - photoRadius;
                  final infoTop = h * _infoTopFraction;
                  final qrTop =
                      photoTop - _qrSize - _qrGapAbovePhoto + _qrVerticalOffset;

                  return SizedBox(
                    width: w,
                    height: h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _ktmAsset,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: w * 0.80 - _qrSize * 0.5,
                          top: qrTop,
                          width: _qrSize,
                          height: _qrSize,
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(4),
                            child: QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: _qrSize - 8,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          left: w * _photoCenterXFraction - photoRadius,
                          top: photoTop,
                          width: photoRadius * 2,
                          height: photoRadius * 2,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: fotoUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: fotoUrl,
                                      fit: BoxFit.cover,
                                      width: photoRadius * 2,
                                      height: photoRadius * 2,
                                      placeholder: (_, __) =>
                                          _photoPlaceholder(photoRadius * 2),
                                      errorWidget: (_, __, ___) =>
                                          _photoPlaceholder(photoRadius * 2),
                                    )
                                  : _photoPlaceholder(photoRadius * 2),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          top: infoTop,
                          child: _InfoOverlay(
                            nama: home.isName,
                            npm: home.isNIM,
                            prodi: home.isProdi,
                            program: home.isProgram,
                            status: home.isStatus,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// Generate data QR: NPM + Tanggal lahir (format akhir: NPM + YYMMDD).
  static String _buildQrData(String npm, String tanggalLahir) {
    final tglNorm = _normalizeTanggalLahir(tanggalLahir);
    if (tglNorm.isEmpty) return npm;
    // tglNorm = YYYYMMDD → ambil YYMMDD
    final yyMMdd = tglNorm.length == 8 ? tglNorm.substring(2) : tglNorm;
    print('$npm$yyMMdd');
    return '$npm$yyMMdd';
  }

  /// Normalisasi ke YYYYMMDD. Terima: YYYY-MM-DD, DD-MM-YYYY, DD/MM/YYYY, YYYYMMDD.
  static String _normalizeTanggalLahir(String value) {
    final s = value.trim();
    if (s.isEmpty) return '';
    final onlyDigits = s.replaceAll(RegExp(r'[^\d]'), '');
    if (onlyDigits.length == 8) {
      if (int.tryParse(onlyDigits.substring(0, 4)) != null &&
          (int.tryParse(onlyDigits.substring(0, 4)) ?? 0) > 1900) {
        return onlyDigits;
      }
      final d = onlyDigits.substring(0, 2);
      final m = onlyDigits.substring(2, 4);
      final y = onlyDigits.substring(4, 8);
      return '$y$m$d';
    }
    final parts = s
        .split(RegExp(r'[-/.\s]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.length != 3) return '';
    final a = int.tryParse(parts[0]) ?? 0;
    final b = int.tryParse(parts[1]) ?? 0;
    final c = int.tryParse(parts[2]) ?? 0;
    int y, m, d;
    if (a > 31 || parts[0].length == 4) {
      y = a;
      m = b;
      d = c;
    } else {
      d = a;
      m = b;
      y = c;
    }
    return '${y.toString().padLeft(4, '0')}${m.toString().padLeft(2, '0')}${d.toString().padLeft(2, '0')}';
  }

  Widget _photoPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      color: config.colorGrey,
      child: Icon(Icons.person, size: size * 0.5, color: Colors.grey),
    );
  }
}

class _InfoOverlay extends StatelessWidget {
  final String nama;
  final String npm;
  final String prodi;
  final String program;
  final String status;

  const _InfoOverlay({
    required this.nama,
    required this.npm,
    required this.prodi,
    required this.program,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.grey.shade800,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      height: 1.35,
    );
    final labelStyle = TextStyle(
      color: Colors.grey.shade700,
      fontSize: 11,
      height: 1.35,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _row('Nama', nama, textStyle, labelStyle),
        const SizedBox(height: 6),
        _row('NPM', npm, textStyle, labelStyle),
        const SizedBox(height: 6),
        _row('Program Studi', prodi, textStyle, labelStyle),
        const SizedBox(height: 6),
        _row('Program', program, textStyle, labelStyle),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _row(
    String label,
    String value,
    TextStyle valueStyle,
    TextStyle labelStyle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            '$label:',
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: valueStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
