import '../exceptions/domain_exception.dart';

/// Сутність «Бронювання». Бізнес-правила перевіряються в конструкторі,
/// тому некоректне бронювання створити неможливо.
class Booking {
  static const int minGuests = 1;
  static const int maxGuests = 10;

  final String id;
  final String hotelId;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  Booking({
    required this.id,
    required this.hotelId,
    required this.guestName,
    required DateTime checkIn,
    required DateTime checkOut,
    required this.guests,
  })  : checkIn = _dateOnly(checkIn),
        checkOut = _dateOnly(checkOut) {
    if (!this.checkOut.isAfter(this.checkIn)) {
      throw const DomainException(
        'Дата виїзду має бути пізніше за дату заїзду.',
      );
    }
    if (guests < minGuests || guests > maxGuests) {
      throw DomainException(
        'Кількість гостей має бути від $minGuests до $maxGuests.',
      );
    }
  }

  /// Кількість ночей проживання.
  int get nights {
    final from = DateTime.utc(checkIn.year, checkIn.month, checkIn.day);
    final to = DateTime.utc(checkOut.year, checkOut.month, checkOut.day);
    return to.difference(from).inDays;
  }

  /// Вартість проживання за заданою ціною за ніч.
  int totalPrice(int pricePerNight) => nights * pricePerNight;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
