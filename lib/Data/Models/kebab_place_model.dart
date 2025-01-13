class KebabPlaceModel {
  final int id;
  final String name;
  final String? image;
  final String address;
  final String? latitude;
  final String? longitude;
  final String? googleMapsUrl;
  final String? googleMapsRating;
  final String? phone;
  final String? website;
  final String? email;
  final int? openedAtYear;
  final int? closedAtYear;
  final List<Map<String, dynamic>> openingHours;
  final List<int> fillings;
  final List<int> sauces;
  final String status;
  final bool? isCraft;
  final bool? isChainRestaurant;
  final String locationType;
  final List<String> orderOptions;
  final List<Map<String, dynamic>> socialMedia;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KebabPlaceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.openingHours,
    required this.status,
    required this.locationType,
    required this.orderOptions,
    required this.socialMedia,
    required this.fillings,
    required this.sauces,
    this.image,
    this.latitude,
    this.longitude,
    this.googleMapsUrl,
    this.googleMapsRating,
    this.phone,
    this.website,
    this.email,
    this.openedAtYear,
    this.closedAtYear,
    this.isCraft,
    this.isChainRestaurant,
    this.createdAt,
    this.updatedAt,
  });

  factory KebabPlaceModel.fromJson(Map<String, dynamic> json) {
    return KebabPlaceModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      openingHours: json['opening_hours'] != null
          ? List<Map<String, dynamic>>.from(
              (json['opening_hours'] as List<dynamic>).map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>)),
            )
          : [],
      status: json['status'],
      locationType: json['location_type'],
      orderOptions: json['order_options'] != null
          ? List<String>.from(json['order_options'])
          : [],
      socialMedia: json['social_media'] != null
          ? List<Map<String, dynamic>>.from(
              (json['social_media']as List<dynamic>).map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>)),
            )
          : [],
      image: json['image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      googleMapsUrl: json['google_maps_url'],
      googleMapsRating: json['google_maps_rating'],
      phone: json['phone'],
      website: json['website'],
      email: json['email'],
      openedAtYear: json['opened_at_year'],
      closedAtYear: json['closed_at_year'],
      fillings: json['fillings'] != null ? List<int>.from(json['fillings']) : [],
      sauces: json['sauces'] != null ? List<int>.from(json['sauces']) : [],
      isCraft: json['is_craft'],
      isChainRestaurant: json['is_chain_restaurant'],
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
      'address': address,
      'opening_hours': openingHours,
      'status': status,
      'location_type': locationType,
      'order_options': orderOptions,
      'social_media': socialMedia,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'google_maps_url': googleMapsUrl,
      'google_maps_rating': googleMapsRating,
      'phone': phone,
      'website': website,
      'email': email,
      'opened_at_year': openedAtYear,
      'closed_at_year': closedAtYear,
      'fillings': fillings,
      'sauces': sauces,
      'is_craft': isCraft,
      'is_chain_restaurant': isChainRestaurant,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
