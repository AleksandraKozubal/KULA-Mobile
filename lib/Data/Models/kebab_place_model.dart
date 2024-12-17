class KebabPlaceModel {
  final int id;
  final String name;
  final String street;
  final String buildingNumber;
  final String latitude;
  final String longitude;
  final String googleMapsUrl;
  final String googleMapsRating;
  final String phone;
  final String website;
  final String email;
  final String fillings;
  final String sauces;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  KebabPlaceModel({
    required this.id,
    required this.name,
    required this.street,
    required this.buildingNumber,
    required this.latitude,
    required this.longitude,
    required this.googleMapsUrl,
    required this.googleMapsRating,
    required this.phone,
    required this.website,
    required this.email,
    required this.fillings,
    required this.sauces,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KebabPlaceModel.fromJson(Map<String, dynamic> json) {
    return KebabPlaceModel(
      id: json['id'],
      name: json['name'],
      street: json['street'],
      buildingNumber: json['building_number'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      googleMapsUrl: json['google_maps_url'],
      googleMapsRating: json['google_maps_rating'],
      phone: json['phone'],
      website: json['website'],
      email: json['email'],
      fillings: json['fillings'],
      sauces: json['sauces'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}