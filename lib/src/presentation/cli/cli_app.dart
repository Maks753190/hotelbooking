import 'dart:io';

import '../../application/use_cases/cancel_booking_use_case.dart';
import '../../application/use_cases/create_booking_use_case.dart';
import '../../application/use_cases/list_bookings_use_case.dart';
import '../../application/use_cases/list_hotels_use_case.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Консольний інтерфейс. Не містить бізнес-логіки: лише введення/виведення
/// та виклик use cases, які передані ззовні через конструктор.
class CliApp {
  CliApp({
    required this.listHotels,
    required this.createBooking,
    required this.listBookings,
    required this.cancelBooking,
  });

  final ListHotelsUseCase listHotels;
  final CreateBookingUseCase createBooking;
  final ListBookingsUseCase listBookings;
  final CancelBookingUseCase cancelBooking;

  Future<void> run() async {
    print('=== Бронювання готелів ===');
    while (true) {
      _printMenu();
      final choice = _prompt('Ваш вибір');
      try {
        switch (choice) {
          case '1':
            await _showHotels();
          case '2':
            await _createBooking();
          case '3':
            await _showBookings();
          case '4':
            await _cancelBooking();
          case '0':
            print('До побачення! Дякуємо за користування.');
            return;
          default:
            print('Невідома команда, спробуйте ще раз.');
        }
      } on DomainException catch (e) {
        print('Помилка: ${e.message}');
      } on FormatException catch (e) {
        print('Некоректне введення: ${e.message}');
      }
    }
  }

  void _printMenu() {
    print('');
    print('1 - Список готелів');
    print('2 - Створити бронювання');
    print('3 - Мої бронювання');
    print('4 - Скасувати бронювання');
    print('0 - Вихід');
  }

  Future<void> _showHotels() async {
    final hotels = await listHotels();
    print('');
    for (final h in hotels) {
      print('${h.id.padRight(14)} ${h.name.padRight(24)} '
          '${h.city.padRight(10)} ${h.pricePerNight} грн/ніч  ★ ${h.rating}');
    }
  }

  Future<void> _createBooking() async {
    await _showHotels();
    final hotelId = _prompt('Id готелю');
    final guestName = _prompt('Ім’я гостя');
    final checkIn = _parseDate(_prompt('Дата заїзду (дд.мм.рррр)'));
    final checkOut = _parseDate(_prompt('Дата виїзду (дд.мм.рррр)'));
    final guests = _parseInt(_prompt('Кількість гостей (1-10)'));

    final booking = await createBooking(
      hotelId: hotelId,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
    );
    print('Бронювання створено. Id: ${booking.id}');
  }

  Future<void> _showBookings() async {
    final items = await listBookings();
    if (items.isEmpty) {
      print('Бронювань немає.');
      return;
    }
    print('');
    for (final s in items) {
      final b = s.booking;
      print('${b.id} | ${s.hotelName} | '
          '${_formatDate(b.checkIn)} → ${_formatDate(b.checkOut)} | '
          '${b.guests} гост. | ${s.totalPrice} грн | ${b.guestName}');
    }
  }

  Future<void> _cancelBooking() async {
    final id = _prompt('Id бронювання');
    await cancelBooking(id);
    print('Бронювання скасовано.');
  }

  // ---------- допоміжні методи введення ----------
  String _prompt(String label) {
    stdout.write('$label: ');
    final line = stdin.readLineSync();
    if (line == null) return '0'; // кінець введення — завершити роботу
    return line.trim();
  }

  int _parseInt(String text) {
    final value = int.tryParse(text);
    if (value == null) throw const FormatException('очікується ціле число.');
    return value;
  }

  DateTime _parseDate(String text) {
    final parts = text.split('.');
    if (parts.length != 3) {
      throw const FormatException('дата має бути у форматі дд.мм.рррр.');
    }
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      throw const FormatException('дата має бути у форматі дд.мм.рррр.');
    }
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      throw const FormatException('такої дати не існує.');
    }
    return date;
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day.$month.${d.year}';
  }
}
