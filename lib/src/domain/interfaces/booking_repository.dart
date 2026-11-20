import '../entities/booking.dart';

/// Абстракція сховища бронювань. Реалізація живе в шарі Infrastructure.
abstract interface class BookingRepository {
  Future<List<Booking>> getAll();

  Future<Booking?> getById(String id);

  Future<void> add(Booking booking);

  /// Повертає true, якщо бронювання було знайдено й видалено.
  Future<bool> remove(String id);
}
