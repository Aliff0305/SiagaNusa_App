import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String full(DateTime d) =>
      DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(d);

  static String dateTime(DateTime d) =>
      '${DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(d)} WIB';

  static String shortDate(DateTime d) =>
      DateFormat('d MMM yyyy', 'id_ID').format(d);

  static String time(DateTime d) => '${DateFormat('HH:mm').format(d)} WIB';

  static String ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return shortDate(d);
  }

  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi';
    if (h < 15) return 'Selamat siang';
    if (h < 18) return 'Selamat sore';
    return 'Selamat malam';
  }
}
