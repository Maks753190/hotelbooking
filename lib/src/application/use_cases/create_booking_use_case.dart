import '../../domain/entities/booking.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/interfaces/booking_repository.dart';
import '../../domain/interfaces/hotel_repository.dart';

/// Use case: створити бронювання.
/// Залежить лише від інтерфейсів домену (принцип інверсії залежностей).
class CreateBookingUseCase {
  final HotelRepository _hotels;
  final BookingRepository _bookings;

  CreateBookingUseCase(this._hotels, this._bookings);

  Future<Booking> call({
    required String hotelId,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
  }) async {
    final hotel = await _hotels.getById(hotelId);
    if (hotel == null) {
      throw DomainException('Готель з id "$hotelId" не знайдено.');
    }

    final booking = Booking(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      hotelId: hotel.id,
      guestName: guestName.trim(),
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
    );
    await _bookings.add(booking);
    return booking;
  }
}
