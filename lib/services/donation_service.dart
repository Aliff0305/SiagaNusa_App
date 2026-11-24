import 'package:siaganusa/models/campaign_model.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/donation_model.dart';

class DonationService {
  final List<DonationModel> _history = [];

  Future<List<CampaignModel>> fetchCampaigns() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    // DATA CONTOH. Kampanye asli harus diverifikasi BNPB/BPBD/mitra kemanusiaan.
    return [
      CampaignModel(
        id: 'c1',
        title: 'Bantuan pengungsi gempa Maluku Tengah',
        location: 'Maluku Tengah, Maluku',
        type: DisasterType.earthquake,
        description: 'Ratusan keluarga mengungsi setelah gempa merusak rumah mereka. Dana digunakan untuk makanan, air bersih, selimut, dan tenda darurat.',
        organizer: 'Palang Merah Indonesia (contoh)',
        target: 250000000,
        collected: 148500000,
        donors: 1320,
        deadline: now.add(const Duration(days: 21)),
        verified: true,
        verifiedBy: 'BPBD Provinsi Maluku (contoh)',
        updates: [
          CampaignUpdate(
            now.subtract(const Duration(days: 1)),
            'Tim relawan menyalurkan 300 paket makanan ke 3 posko pengungsian.',
          ),
          CampaignUpdate(
            now.subtract(const Duration(days: 3)),
            'Kampanye dibuka setelah verifikasi kebutuhan oleh BPBD.',
          ),
        ],
        allocation: const [
          FundAllocation('Makanan & air bersih', 45),
          FundAllocation('Tenda & selimut', 30),
          FundAllocation('Layanan kesehatan', 15),
          FundAllocation('Operasional relawan', 10),
        ],
      ),
      CampaignModel(
        id: 'c2',
        title: 'Masker dan layanan kesehatan korban asap Riau',
        location: 'Pelalawan, Riau',
        type: DisasterType.wildfire,
        description: 'Asap karhutla mengganggu kesehatan warga. Dana untuk masker N95, posko kesehatan, dan penyaring udara di sekolah.',
        organizer: 'Mitra Kemanusiaan Riau (contoh)',
        target: 100000000,
        collected: 37200000,
        donors: 486,
        deadline: now.add(const Duration(days: 14)),
        verified: true,
        verifiedBy: 'BPBD Provinsi Riau (contoh)',
        updates: [
          CampaignUpdate(
            now.subtract(const Duration(days: 2)),
            '2.000 masker dibagikan di 4 desa.',
          ),
        ],
        allocation: const [
          FundAllocation('Masker & alat pelindung', 50),
          FundAllocation('Posko kesehatan', 35),
          FundAllocation('Operasional', 15),
        ],
      ),
      CampaignModel(
        id: 'c3',
        title: 'Rehabilitasi rumah warga terdampak gempa Malang',
        location: 'Malang, Jawa Timur',
        type: DisasterType.earthquake,
        description: 'Perbaikan rumah rusak ringan hingga sedang milik warga prasejahtera di wilayah terdampak.',
        organizer: 'Yayasan Peduli Jatim (contoh)',
        target: 180000000,
        collected: 12000000,
        donors: 64,
        deadline: now.add(const Duration(days: 40)),
        verified: false,
        verifiedBy: 'Menunggu verifikasi',
        allocation: const [
          FundAllocation('Material bangunan', 70),
          FundAllocation('Tenaga tukang', 25),
          FundAllocation('Operasional', 5),
        ],
      ),
    ];
  }

  Future<List<DonationModel>> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_history);
  }

  Future<DonationModel> donate({
    required CampaignModel campaign,
    required double amount,
    required String method,
    required bool anonymous,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final now = DateTime.now();
    final d = DonationModel(
      id: 'd${now.millisecondsSinceEpoch}',
      campaignId: campaign.id,
      campaignTitle: campaign.title,
      amount: amount,
      method: method,
      time: now,
      receiptNo:
          'SN-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch % 100000}',
      anonymous: anonymous,
    );
    _history.insert(0, d);
    return d;
  }
}
