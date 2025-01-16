import 'package:equatable/equatable.dart';

class LocationInfo extends Equatable {
  final double lat;
  final double long;
  final DateTime date;
  final String? address;
  const LocationInfo({
    required this.lat,
    required this.long,
    required this.date,
    this.address,
  });

  LocationInfo copyWith({
    double? lat,
    double? long,
    DateTime? date,
    String? address,
  }) {
    return LocationInfo(
      lat: lat ?? this.lat,
      long: long ?? this.long,
      date: date ?? this.date,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
        lat,
        long,
        date,
        address,
      ];
}
