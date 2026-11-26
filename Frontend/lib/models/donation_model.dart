class DonationModel {
  final String id;
  final String campaignId;
  final String campaignTitle;
  final double amount;
  final String method;
  final DateTime time;
  final String receiptNo;
  final bool anonymous;
  final String status; // Berhasil, Menunggu

  const DonationModel({
    required this.id,
    required this.campaignId,
    required this.campaignTitle,
    required this.amount,
    required this.method,
    required this.time,
    required this.receiptNo,
    this.anonymous = false,
    this.status = 'Berhasil',
  });
}
