import 'package:flutter/material.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/core/utils/validators.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({super.key});

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _target = TextEditingController();
  final _description = TextEditingController();
  final _organizer = TextEditingController();
  DisasterType _type = DisasterType.earthquake;
  bool _submitting = false;

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _target.dispose();
    _description.dispose();
    _organizer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    // TODO: kirim ke backend. Saat ini hanya simulasi.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _submitting = false);
    Helpers.snack(
      context,
      'Pengajuan terkirim. Kampanye dibuka setelah diverifikasi.',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Ajukan kampanye'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            const InfoBanner(
              icon: Icons.verified_user_outlined,
              message: 'Pengajuan akan diverifikasi oleh pihak berwenang atau mitra kemanusiaan sebelum tampil ke publik.',
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _title,
              label: 'Judul kampanye',
              validator: (v) => Validators.minLength(v, 10, 'Judul'),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<DisasterType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Jenis bencana'),
              items: [
                for (final t in DisasterType.values)
                  DropdownMenuItem(value: t, child: Text(t.label)),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _location,
              label: 'Lokasi terdampak',
              icon: Icons.place_outlined,
              validator: (v) => Validators.required(v, 'Lokasi'),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _organizer,
              label: 'Nama penyelenggara / lembaga',
              validator: (v) => Validators.required(v, 'Penyelenggara'),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _target,
              label: 'Target dana',
              prefixText: 'Rp ',
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = double.tryParse((v ?? '').replaceAll('.', ''));
                return (n == null || n < 1000000)
                    ? 'Target minimal Rp 1.000.000'
                    : null;
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _description,
              label: 'Kebutuhan bantuan dan rencana penggunaan dana',
              maxLines: 6,
              validator: (v) => Validators.minLength(v, 50, 'Deskripsi'),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Kirim pengajuan',
              icon: Icons.send,
              onPressed: _submit,
              loading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}
