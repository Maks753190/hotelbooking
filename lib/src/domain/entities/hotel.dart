/// Сутність «Готель».
class Hotel {
  final String id;
  final String name;
  final String city;

  /// Ціна за ніч, грн.
  final int pricePerNight;
  final double rating;

  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.pricePerNight,
    required this.rating,
  });
}
@override
  String toString() => 'Hotel($name, $city, $pricePerNight грн/ніч)';