# Архітектура застосунку «Бронювання готелів»

Застосунок побудований за принципами Clean Architecture. Залежності
спрямовані лише всередину: зовнішні шари знають про внутрішні, але не навпаки.

| Шар | Каталог | Відповідальність | Залежить від |
|-----|---------|------------------|--------------|
| Domain | `lib/src/domain` | Сутності (`Hotel`, `Booking`), бізнес-правила, інтерфейси репозиторіїв | нічого |
| Application | `lib/src/application` | Use cases: перегляд готелів, створення, перегляд і скасування бронювань | Domain |
| Infrastructure | `lib/src/infrastructure` | Реалізації репозиторіїв (InMemory, JSON-файл) | Domain |
| Presentation | `bin`, `lib/src/presentation` | Консольне меню, точка входу, збирання залежностей (DI) | Application, Domain, Infrastructure (лише в точці входу) |

## Правило залежностей

```
Presentation ──► Application ──► Domain ◄── Infrastructure
```

Application працює лише з інтерфейсами `HotelRepository` і `BookingRepository`,
оголошеними в Domain. Конкретні реалізації підставляються в точці входу
`bin/hotel_booking.dart` (Dependency Injection).
