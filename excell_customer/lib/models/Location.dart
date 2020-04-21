import 'dart:convert';

class Location {
  final String location_id;
  final String location;
  Location({
    this.location_id,
    this.location,
  });

  Location copyWith({
    String location_id,
    String location,
  }) {
    return Location(
      location_id: location_id ?? this.location_id,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location_id': location_id,
      'location': location,
    };
  }

  static Location fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Location(
      location_id: map['location_id'],
      location: map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  static Location fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Location(location_id: $location_id, location: $location)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Location &&
      o.location_id == location_id &&
      o.location == location;
  }

  @override
  int get hashCode => location_id.hashCode ^ location.hashCode;
}