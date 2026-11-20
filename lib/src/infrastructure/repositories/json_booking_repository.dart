import 'dart:convert';
import 'dart:io';

import '../../domain/entities/booking.dart';
import '../../domain/interfaces/booking_repository.dart';

/// Реалізація BookingRepository: бронювання зберігаються у JSON-файлі.
class JsonBookingRepository implements BookingRepository {
  final String filePath;

  JsonBookingRepository(this.filePath);

  @override
  Future<List<Booking>> getAll() => _read();

  @override
  Future<Booking?> getById(String id) async {
    final bookings = await _read();
    for (final booking in bookings) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  @override
  Future<void> add(Booking booking) async {
    final bookings = await _read();
    bookings.add(booking);
    await _write(bookings);
  }

  @override
  Future<bool> remove(String id) async {
    final bookings = await _read();
    final before = bookings.length;
    bookings.removeWhere((booking) => booking.id == id);
    if (bookings.length == before) return false;
    await _write(bookings);
    return true;
  }

  Future<List<Booking>> _read() async {
    final source = File(filePath);
    if (!await source.exists()) return [];
    final text = await source.readAsString();
    if (text.trim().isEmpty) return [];
    final data = jsonDecode(text) as List<dynamic>;
    return data
        .map((item) => _fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _write(List<Booking> bookings) async {
    final file = File(filePath);
Future<void> _write(List<Booking> bookings) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);
    final content = const JsonEncoder.withIndent('  ')
    final content = const JsonEncoder.withIndent('  ')
        .convert(bookings.map(_toJson).toList());
    await file.writeAsString(content);
  }

  // Перетворення сутності на JSON — відповідальність Infrastructure,
  // тому Domain нічого не знає про формат зберігання.
  Map<String, dynamic> _toJson(Booking booking) => {
        'id': booking.id,
        'hotelId': booking.hotelId,
        'guestName': booking.guestName,
        'checkIn': booking.checkIn.toIso8601String(),
        'checkOut': booking.checkOut.toIso8601String(),
        'guests': booking.guests,
      };

  Booking _fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        hotelId: json['hotelId'] as String,
        guestName: json['guestName'] as String,
        checkIn: DateTime.parse(json['checkIn'] as String),
        checkOut: DateTime.parse(json['checkOut'] as String),
        guests: json['guests'] as int,
      );
}
