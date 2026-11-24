import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/campaign_model.dart';
import 'package:siaganusa/providers/donation_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class DonationPaymentScreen extends StatefulWidget {
  final CampaignModel campaign;
  const DonationPaymentScreen({super.key, required this.campaign});

  @override
  State<DonationPaymentScreen> createState() => _DonationPaymentScreenState();
}

class _DonationPaymentScreenState extends State<DonationPaymentScreen> {
  static const _presets = [10000, 25000, 50000, 100000, 250000];
  static const _methods = ['QRIS', 'Transfer virtual account', 'E-wallet'];

  final _custom = TextEditingController();
  int? _preset = 50000;
  String _method = _methods.first;
  bool _anonymous = false;

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  double get _amount {
    final custom = double.tryParse(_custom.text.replaceAll('.', '').trim());
    return custom ?? (_preset?.toDouble() ?? 0);
  }

  Future<void> _pay() async {
    final amount = _amount;
    if (amount < 10000) {
      Helpers.snack(context, 'Minimal donasi Rp 10.000', error: true);
      return;
    }
    final provider = context.read<DonationProvider>();
    final donation = await provider.donate(
      campaign: widget.campaign,
      amount: amount,
      method: _method,
      anonymous: _anonymous,
    );
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      RouteNames.donationSuccess,
      arguments: donation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final paying = context.watch<DonationProvider>().isPaying;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Pembayaran donasi'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Untuk kampanye', style: t.bodySmall),
                const SizedBox(height: 4),
                Text(
                  widget.campaign.title,
                  style: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Nominal donasi'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _presets)
                ChoiceChip(
                  label: Text(Helpers.rupiah(p)),
                  selected: _preset == p && _custom.text.isEmpty,
                  onSelected: (_) => setState(() {
                    _preset = p;
                    _custom.clear();
                  }),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _custom,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nominal lain',
              prefixText: 'Rp ',
            ),
            onChanged: (_) => setState(() => _preset = null),
          ),
          const SectionHeader(title: 'Metode pembayaran'),
          for (final m in _methods)
            AppCard(
              margin: const EdgeInsets.only(bottom: 8),
              onTap: () => setState(() => _method = m),
              child: Row(
                children: [
                  Icon(
                    _method == m
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: _method == m
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      m,
                      style: t.bodyMedium?.copyWith(
                        fontWeight: _method == m
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SwitchListTile(
            value: _anonymous,
            onChanged: (v) => setState(() => _anonymous = v),
            title: const Text('Donasi sebagai anonim'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          const InfoBanner(
            message: 'Pembayaran masih simulasi. Integrasi QRIS dan payment gateway ditambahkan saat backend siap.',
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Bayar ${Helpers.rupiah(_amount)}',
            icon: Icons.lock_outline,
            onPressed: _pay,
            loading: paying,
          ),
        ],
      ),
    );
  }
}
