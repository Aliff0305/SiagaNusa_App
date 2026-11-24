class Validators {
  Validators._();

  static String? required(String? v, [String field = 'Kolom ini']) =>
      (v == null || v.trim().isEmpty) ? '$field wajib diisi' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(v.trim());
    return ok ? null : 'Format email tidak valid';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
    if (v.length < 6) return 'Kata sandi minimal 6 karakter';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nomor HP wajib diisi';
    final ok = RegExp(r'^(\+62|62|0)8[0-9]{8,12}$').hasMatch(v.trim());
    return ok ? null : 'Nomor HP tidak valid (contoh: 08123456789)';
  }

  static String? minLength(String? v, int min, [String field = 'Kolom ini']) {
    if (v == null || v.trim().length < min) {
      return '$field minimal $min karakter';
    }
    return null;
  }
}
