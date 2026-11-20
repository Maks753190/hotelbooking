import '../../domain/exceptions/domain_exception.dart';
import '../../domain/interfaces/booking_repository.dart';

/// Use case: скасувати бронювання за його id.
class CancelBookingUseCase {
  final BookingRepository _bookings;

  CancelBookingUseCase(this._bookings);

  Future<void> call(String bookingId) async {
    final removed = await _bookings.remove(bookingId);
    if (!removed) {
      throw DomainException('Бронювання "$bookingId" не знайдено.');
    }
  }
}
