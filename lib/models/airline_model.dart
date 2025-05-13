class Airline {
  final String name;
  final String? icaoCode;
  final String? iataCode;
  final String? country;

  Airline({
    required this.name,
    this.icaoCode,
    this.iataCode,
    this.country,
  });

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      name: json['airline_name'] ?? 'Unknown',
      icaoCode: json['icao_code'],
      iataCode: json['iata_code'],
      country: json['country_name'],
    );
  }
}
