import '../../domain/entities/booking.dart';
import '../../domain/interfaces/booking_repository.dart';
import '../../domain/interfaces/hotel_repository.dart';

/// Готове до показу бронювання: назва готелю та загальна вартість.
class BookingSummary {
  final Booking booking;
  final String hotelName;
  final int totalPrice;

  const BookingSummary({
    required this.booking,
    required this.hotelName,
    required this.totalPrice,
  });
}

/// Use case: отримати список бронювань із назвою готелю та сумою.
class ListBookingsUseCase {
  final HotelRepository _hotels;
  final BookingRepository _bookings;

  ListBookingsUseCase(this._hotels, this._bookings);

  Future<List<BookingSummary>> call() async {
    final bookings = await _bookings.getAll();
    final result = <BookingSummary>[];
    for (final booking in bookings) {
      final hotel = await _hotels.getById(booking.hotelId);
      result.add(
        BookingSummary(
          booking: booking,
          hotelName: hotel?.name ?? 'Невідомий готель',
          totalPrice:
              hotel == null ? 0 : booking.totalPrice(hotel.pricePerNight),
        ),
      );
    }
    return result;
  }
}
