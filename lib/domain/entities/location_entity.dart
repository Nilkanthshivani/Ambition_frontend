class LocationEntity {
  final String type;
  final List<num> coordinates;
  final String? name;
  final String? address;

  LocationEntity({
    required this.type,
    required this.coordinates,
    this.name,
    this.address,
  });
}
