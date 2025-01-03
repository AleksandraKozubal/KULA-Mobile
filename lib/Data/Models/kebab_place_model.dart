class KebabPlaceModel {
  final int id;
  final String name;
  final String street;
  final String? buildingNumber;
  final String? latitude;
  final String? longitude;
  final String? googleMapsUrl;
  final String? googleMapsRating;
  final String? phone;
  final String? website;
  final String? email;
  final String? fillings;
  final String? sauces;
  final String? openingHours;
  final String? yearEstablished;
  final bool? isKraft;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KebabPlaceModel({
    required this.id,
    required this.name,
    required this.street,
    this.buildingNumber,
    this.latitude,
    this.longitude,
    this.googleMapsUrl,
    this.googleMapsRating,
    this.phone,
    this.website,
    this.email,
    this.fillings,
    this.sauces,
    this.openingHours,
    this.yearEstablished,
    this.isKraft,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory KebabPlaceModel.fromJson(Map<String, dynamic> json) {
    return KebabPlaceModel(
      id: json['id'],
      name: json['name'],
      street: json['street'],
      buildingNumber: json['building_number'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      googleMapsUrl: json['google_maps_url'] ?? '',
      googleMapsRating: json['google_maps_rating'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      email: json['email'] ?? '',
      fillings: json['fillings'] ?? '',
      sauces: json['sauces'] ?? '',
      openingHours: json['opening_hours'] ?? '',
      yearEstablished: json['year_of_establishment'] ?? '',
      isKraft: json['is_kraft'] ?? false,
      image: json['image'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'building_number': buildingNumber,
      'latitude': latitude,
      'longitude': longitude,
      'google_maps_url': googleMapsUrl,
      'google_maps_rating': googleMapsRating,
      'phone': phone,
      'website': website,
      'email': email,
      'fillings': fillings,
      'sauces': sauces,
      'opening_hours': openingHours,
      'year_established': yearEstablished,
      'is_kraft': isKraft,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
