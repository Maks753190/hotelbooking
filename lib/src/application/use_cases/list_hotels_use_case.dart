import '../../domain/entities/hotel.dart';
import '../../domain/interfaces/hotel_repository.dart';

/// Use case: отримати список готелів.
class ListHotelsUseCase {
  final HotelRepository _hotels;

  ListHotelsUseCase(this._hotels);

  Future<List<Hotel>> call() => _hotels.getAll();
}
