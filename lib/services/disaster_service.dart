import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/services/earthquake_service.dart';
import 'package:siaganusa/services/hotspot_service.dart';
import 'package:siaganusa/services/tsunami_service.dart';
import 'package:siaganusa/models/earthquake_model.dart';
import 'package:siaganusa/models/hotspot_model.dart';
import 'package:siaganusa/models/tsunami_model.dart';

class DisasterBundle {
  final List<EarthquakeModel> earthquakes;
  final List<TsunamiModel> tsunamis;
  final List<HotspotModel> hotspots;
  const DisasterBundle(this.earthquakes, this.tsunamis, this.hotspots);
}

class DisasterService {
  final _eq = EarthquakeService();
  final _ts = TsunamiService();
  final _hs = HotspotService();

  Future<DisasterBundle> fetchAll() async {
    final r = await Future.wait([_eq.fetch(), _ts.fetch(), _hs.fetch()]);
    return DisasterBundle(
      r[0] as List<EarthquakeModel>,
      r[1] as List<TsunamiModel>,
      r[2] as List<HotspotModel>,
    );
  }

  // ---------------------------------------------------------------------------
  // ANALISIS SISTEM. Heuristik sederhana untuk membantu pengguna memahami
  // data resmi. Hasilnya BUKAN pernyataan resmi dan harus ditampilkan dengan
  // label "Analisis sistem" / "Perkiraan dampak".
  // ---------------------------------------------------------------------------
  static ImpactAnalysis analyze(DisasterModel d, List<DisasterModel> all) {
    switch (d.type) {
      case DisasterType.earthquake:
        return _earthquake(d.earthquake!);
      case DisasterType.tsunami:
        return _tsunami(d.tsunami!);
      case DisasterType.wildfire:
        return _wildfire(d.hotspot!, all);
    }
  }

  static Severity _level(int score) {
    if (score >= 75) return Severity.critical;
    if (score >= 55) return Severity.high;
    if (score >= 30) return Severity.moderate;
    return Severity.low;
  }

  static ImpactAnalysis _earthquake(EarthquakeModel q) {
    final mag = ((q.magnitude - 3) / 5).clamp(0.0, 1.0);
    final depth = (1 - q.depthKm / 300).clamp(0.0, 1.0);
    final tsu = q.hasTsunamiPotential ? 0.8 : 0.1;
    final score = ((mag * 0.5 + depth * 0.25 + tsu * 0.25) * 100).round();

    final impacts = <String>[
      if (q.magnitude < 4)
        'Getaran ringan, umumnya tidak menimbulkan kerusakan.'
      else if (q.magnitude < 5)
        'Getaran terasa jelas. Barang di rumah dapat bergeser atau jatuh.'
      else if (q.magnitude < 6)
        'Bangunan yang kurang kokoh dapat retak atau rusak ringan.'
      else if (q.magnitude < 7)
        'Kerusakan bangunan sedang hingga berat mungkin terjadi di sekitar pusat gempa.'
      else
        'Kerusakan luas dan korban jiwa mungkin terjadi di wilayah dekat pusat gempa.',
      if (q.depthKm < 70)
        'Gempa dangkal, getaran di permukaan cenderung lebih kuat.',
      if (q.hasTsunamiPotential)
        'Wilayah pesisir dekat pusat gempa perlu waspada gelombang laut.',
      'Gempa susulan masih mungkin terjadi dalam beberapa jam hingga hari ke depan.',
    ];

    return ImpactAnalysis(
      riskScore: score,
      riskLevel: _level(score),
      factors: [
        RiskFactor('Magnitudo', mag, 'M${q.magnitude.toStringAsFixed(1)}'),
        RiskFactor(
          'Kedalaman dangkal',
          depth,
          '${q.depthKm.toStringAsFixed(0)} km (makin dangkal makin berisiko)',
        ),
        RiskFactor(
          'Potensi tsunami',
          tsu,
          q.hasTsunamiPotential
              ? 'Ada potensi menurut BMKG'
              : 'Tidak berpotensi menurut BMKG',
        ),
      ],
      potentialImpacts: impacts,
      causes: [
        'Gempa umumnya dipicu pergerakan lempeng atau sesar aktif di bawah permukaan.',
        if (q.depthKm < 70)
          'Kedalaman dangkal menunjukkan sumber gempa berada di kerak bumi bagian atas.'
        else
          'Kedalaman menengah hingga dalam biasanya terkait zona subduksi.',
        'Mekanisme pasti hanya dapat ditentukan oleh BMKG setelah analisis lanjutan.',
      ],
      recommendations: [
        'Tetap tenang. Jauhi kaca, lemari, dan bangunan yang retak.',
        'Periksa kondisi rumah sebelum masuk kembali.',
        'Siapkan tas siaga dan ketahui jalur evakuasi terdekat.',
        'Ikuti informasi resmi BMKG dan BPBD setempat.',
        if (q.hasTsunamiPotential) 'Jika di pesisir, menjauh dari pantai ke tempat tinggi sampai ada pembaruan resmi.',
      ],
      disclaimer:
          'Perkiraan umum dari magnitudo, kedalaman, dan potensi tsunami. '
          'Dampak nyata bergantung pada jenis tanah, kualitas bangunan, dan jarak ke pusat gempa.',
    );
  }

  static ImpactAnalysis _tsunami(TsunamiModel t) {
    final score = switch (t.status) {
      TsunamiStatus.none => 8,
      TsunamiStatus.watch => 68,
      TsunamiStatus.warning => 92,
    };
    return ImpactAnalysis(
      riskScore: score,
      riskLevel: _level(score),
      factors: [
        RiskFactor('Status peringatan', score / 100, t.status.label),
        RiskFactor(
          'Wilayah terdampak',
          (t.regions.length / 6).clamp(0.0, 1.0),
          '${t.regions.length} wilayah disebut dalam peringatan',
        ),
      ],
      potentialImpacts: switch (t.status) {
        TsunamiStatus.none => [
          'Tidak ada ancaman tsunami menurut BMKG untuk kejadian ini.',
          'Perubahan permukaan laut kecil tetap mungkin terjadi.',
        ],
        TsunamiStatus.watch => [
          'Kenaikan muka air laut dan arus kuat mungkin terjadi di pesisir.',
          'Aktivitas di pantai dan pelabuhan berisiko.',
        ],
        TsunamiStatus.warning => [
          'Gelombang tsunami dapat menggenangi daratan pesisir.',
          'Kerusakan infrastruktur pesisir dan korban jiwa mungkin terjadi.',
        ],
      },
      causes: const [
        'Tsunami umumnya dipicu gempa bawah laut dangkal, longsor bawah laut, atau letusan gunung api.',
        'Penentuan status dilakukan oleh InaTEWS BMKG.',
      ],
      recommendations: switch (t.status) {
        TsunamiStatus.none => const [
          'Tidak perlu evakuasi. Tetap ikuti informasi resmi.',
        ],
        _ => const [
          'Segera menjauh dari pantai dan sungai dekat muara menuju tempat tinggi.',
          'Jangan menunggu gelombang terlihat. Ikuti arahan petugas.',
          'Tetap di tempat aman sampai BMKG menyatakan peringatan berakhir.',
          'Gunakan jalur evakuasi resmi dan hindari menyetir bila bisa berjalan.',
        ],
      },
      disclaimer:
          'Skor ini hanya ringkasan dari status resmi InaTEWS. '
          'Untuk keputusan evakuasi, ikuti pengumuman BMKG, BNPB, dan BPBD.',
    );
  }

  static ImpactAnalysis _wildfire(HotspotModel h, List<DisasterModel> all) {
    final sameProv = all.where((d) => d.hotspot?.province == h.province).length;
    final conf = h.confidence / 100;
    final density = (sameProv / 5).clamp(0.0, 1.0);
    final score = ((conf * 0.6 + density * 0.4) * 100).round();
    return ImpactAnalysis(
      riskScore: score,
      riskLevel: _level(score),
      factors: [
        RiskFactor('Tingkat kepercayaan satelit', conf, '${h.confidence}%'),
        RiskFactor(
          'Jumlah titik di provinsi sama',
          density,
          '$sameProv titik di ${h.province}',
        ),
      ],
      potentialImpacts: const [
        'Asap dapat menurunkan kualitas udara dan jarak pandang di sekitar lokasi.',
        'Risiko gangguan pernapasan terutama bagi anak, lansia, dan penderita asma.',
        'Titik panas belum tentu kebakaran. Perlu verifikasi petugas di lapangan.',
      ],
      causes: const [
        'Titik panas adalah anomali suhu yang terdeteksi satelit, bisa berasal dari kebakaran atau sumber panas lain.',
        'Kebakaran lahan sering terkait pembukaan lahan dan kondisi kering, terutama di lahan gambut.',
      ],
      recommendations: const [
        'Gunakan masker N95/KN95 bila udara berasap.',
        'Kurangi aktivitas di luar ruangan saat kualitas udara buruk.',
        'Jangan membakar lahan atau sampah. Laporkan api ke pihak berwenang.',
        'Pantau informasi resmi dari Sipongi dan BPBD setempat.',
      ],
      disclaimer:
          'Analisis memakai tingkat kepercayaan dan jumlah titik di provinsi yang sama. '
          'Luas area terbakar dan kualitas udara tidak tersedia dalam data ini.',
    );
  }
}
