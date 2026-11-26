import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/core/utils/validators.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/providers/report_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class CreateReportScreen extends StatefulWidget {
  final DisasterModel? related;
  const CreateReportScreen({super.key, this.related});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  static const _categories = [
    'Kerusakan bangunan',
    'Korban atau warga terdampak',
    'Asap / kebakaran lahan',
    'Banjir atau genangan air laut',
    'Kebutuhan bantuan mendesak',
    'Lainnya',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _location = TextEditingController(
    text: widget.related?.location ?? '',
  );
  final _description = TextEditingController();
  String _category = _categories.first;
  XFile? _photo;

  @override
  void dispose() {
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) setState(() => _photo = file);
    } catch (_) {
      if (mounted)
        Helpers.snack(context, 'Tidak dapat membuka galeri', error: true);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ReportProvider>();
    await provider.submit(
      category: _category,
      location: _location.text.trim(),
      description: _description.text.trim(),
      photoName: _photo?.name,
    );
    if (!mounted) return;
    Helpers.snack(context, 'Laporan terkirim. Tim akan memverifikasi.');
    Navigator.pushReplacementNamed(context, RouteNames.reportHistory);
  }

  @override
  Widget build(BuildContext context) {
    final submitting = context.watch<ReportProvider>().isSubmitting;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Laporkan kondisi'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            children: [
              const InfoBanner(
                message: 'Laporan kamu diverifikasi sebelum dipakai. Untuk keadaan darurat, hubungi 112 atau 117 terlebih dahulu.',
              ),
              if (widget.related != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Terkait: ${widget.related!.title}',
                  style: t.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Jenis laporan'),
                items: [
                  for (final c in _categories)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => setState(() => _category = v ?? _category),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _location,
                label: 'Lokasi',
                hint: 'Desa/kelurahan, kecamatan, kota',
                icon: Icons.place_outlined,
                validator: (v) => Validators.required(v, 'Lokasi'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _description,
                label: 'Kondisi di lapangan',
                hint: 'Ceritakan apa yang terjadi, kapan, dan siapa yang terdampak',
                maxLines: 5,
                validator: (v) => Validators.minLength(v, 15, 'Deskripsi'),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.photo_outlined),
                label: Text(
                  _photo == null
                      ? 'Tambah foto (opsional)'
                      : 'Foto: ${_photo!.name}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Kirim laporan',
                icon: Icons.send,
                onPressed: _submit,
                loading: submitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
