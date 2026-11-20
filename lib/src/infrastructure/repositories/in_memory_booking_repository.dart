import '../../domain/entities/booking.dart';
import '../../domain/interfaces/booking_repository.dart';

/// Реалізація BookingRepository: дані зберігаються в пам'яті
/// й зникають після завершення програми.
class InMemoryBookingRepository implements BookingRepository {
  final List<Booking> _items = [];

  @override
  Future<List<Booking>> getAll() async => List.unmodifiable(_items);

  @override
  Future<Booking?> getById(String id) async {
    for (final booking in _items) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  @override
  Future<void> add(Booking booking) async {
    _items.add(booking);
  }

  @override
  Future<bool> remove(String id) async {
    final before = _items.length;
    _items.removeWhere((booking) => booking.id == id);
    return _items.length < before;
  }
}
