import 'package:hotel_booking/src/application/use_cases/cancel_booking_use_case.dart';
import 'package:hotel_booking/src/application/use_cases/create_booking_use_case.dart';
import 'package:hotel_booking/src/application/use_cases/list_bookings_use_case.dart';
import 'package:hotel_booking/src/application/use_cases/list_hotels_use_case.dart';
import 'package:hotel_booking/src/domain/interfaces/booking_repository.dart';
import 'package:hotel_booking/src/domain/interfaces/hotel_repository.dart';
import 'package:hotel_booking/src/infrastructure/repositories/in_memory_booking_repository.dart';
import 'package:hotel_booking/src/infrastructure/repositories/in_memory_hotel_repository.dart';
import 'package:hotel_booking/src/infrastructure/repositories/json_booking_repository.dart';
import 'package:hotel_booking/src/presentation/cli/cli_app.dart';
import 'package:hotel_booking/src/presentation/config/app_settings.dart';

/// Точка входу (composition root): тут, і лише тут, створюються конкретні
/// реалізації та передаються в use cases через конструктор (DI).
Future<void> main() async {
  final settings = await AppSettings.load('config/settings.json');

  final HotelRepository hotelRepository = InMemoryHotelRepository();
  final BookingRepository bookingRepository = switch (settings.storage) {
    'json' => JsonBookingRepository(settings.bookingsFile),
    _ => InMemoryBookingRepository(),
  };

  final app = CliApp(
    listHotels: ListHotelsUseCase(hotelRepository),
    createBooking: CreateBookingUseCase(hotelRepository, bookingRepository),
    listBookings: ListBookingsUseCase(hotelRepository, bookingRepository),
    cancelBooking: CancelBookingUseCase(bookingRepository),
  );

  await app.run();
}
