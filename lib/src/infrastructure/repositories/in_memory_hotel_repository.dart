import '../../domain/entities/hotel.dart';
import '../../domain/interfaces/hotel_repository.dart';

/// Реалізація HotelRepository: дані зберігаються в пам'яті.
class InMemoryHotelRepository implements HotelRepository {
  static const List<Hotel> _seed = [
    Hotel(
      id: 'carpathian',
      name: 'Grand Carpathian Hotel',
      city: 'Буковель',
      pricePerNight: 2450,
      rating: 4.8,
    ),
    Hotel(
      id: 'mountain-view',
      name: 'Mountain View',
      city: 'Яремче',
      pricePerNight: 1900,
      rating: 4.6,
    ),
    Hotel(
      id: 'alpine-lodge',
      name: 'Alpine Lodge',
      city: 'Славське',
      pricePerNight: 2100,
      rating: 4.7,
    ),
    Hotel(
      id: 'forest-resort',
      name: 'Forest Resort',
      city: 'Ворохта',
      pricePerNight: 2800,
      rating: 4.9,
    ),
    Hotel(
      id: 'river-side',
      name: 'River Side',
      city: 'Косів',
      pricePerNight: 1650,
      rating: 4.4,
    ),
  ];

  final List<Hotel> _hotels;

  InMemoryHotelRepository([List<Hotel>? hotels]) : _hotels = hotels ?? _seed;

  @override
  Future<List<Hotel>> getAll() async => List.unmodifiable(_hotels);

  @override
  Future<Hotel?> getById(String id) async {
    for (final hotel in _hotels) {
      if (hotel.id == id) return hotel;
    }
    return null;
  }
}
