import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/core/utils/validators.dart';
import 'package:siaganusa/providers/auth_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _city;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final u = context.read<AuthProvider>().user;
    _name = TextEditingController(text: u?.name ?? '');
    _phone = TextEditingController(text: u?.phone ?? '');
    _city = TextEditingController(text: u?.city ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await context.read<AuthProvider>().updateProfile(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      city: _city.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    Helpers.snack(context, 'Profil diperbarui');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Ubah profil'),
      body: user == null
          ? const Center(child: Text('Masuk dulu untuk mengubah profil.'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                children: [
                  AppTextField(
                    controller: _name,
                    label: 'Nama lengkap',
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (v) => Validators.minLength(v, 3, 'Nama'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: user.email,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                      helperText: 'Email tidak dapat diubah',
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _phone,
                    label: 'Nomor HP',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? null
                        : Validators.phone(v),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _city,
                    label: 'Kota / kabupaten',
                    icon: Icons.location_city_outlined,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Simpan',
                    onPressed: _save,
                    loading: _saving,
                  ),
                ],
              ),
            ),
    );
  }
}
