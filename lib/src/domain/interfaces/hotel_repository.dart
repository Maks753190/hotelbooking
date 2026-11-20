import '../entities/hotel.dart';

/// Абстракція сховища готелів. Реалізація живе в шарі Infrastructure.
abstract interface class HotelRepository {
  Future<List<Hotel>> getAll();

  Future<Hotel?> getById(String id);
}
