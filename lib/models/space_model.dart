enum SpaceStatus { available, occupied, closed, maintenance }

class SpaceModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final SpaceStatus status;
  final int currentOccupancy;
  final int maxCapacity;
  final List<String> amenities;
  final String openTime;
  final String closeTime;

  const SpaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.currentOccupancy,
    required this.maxCapacity,
    required this.amenities,
    required this.openTime,
    required this.closeTime,
  });

  // Factory for parsing from JSON (simulating Firebase)
  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      status: SpaceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SpaceStatus.closed,
      ),
      currentOccupancy: json['currentOccupancy'] as int? ?? 0,
      maxCapacity: json['maxCapacity'] as int? ?? 0,
      amenities: List<String>.from(json['amenities'] ?? []),
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'status': status.name,
      'currentOccupancy': currentOccupancy,
      'maxCapacity': maxCapacity,
      'amenities': amenities,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}
