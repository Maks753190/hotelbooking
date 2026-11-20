import 'dart:convert';
import 'dart:io';

/// Налаштування застосунку з файлу config/settings.json.
class AppSettings {
  final String storage;
  final String bookingsFile;

  const AppSettings({required this.storage, required this.bookingsFile});

  static Future<AppSettings> load(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      return const AppSettings(storage: 'memory', bookingsFile: 'bookings.json');
    }
    final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return AppSettings(
      storage: map['storage'] as String? ?? 'memory',
      bookingsFile: map['bookingsFile'] as String? ?? 'bookings.json',
    );
  }
}
