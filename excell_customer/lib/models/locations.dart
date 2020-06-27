import 'dart:convert';

class ExcellCity {
  //ignore: non_constant_identifier_names
  final String location_id;
  final String location;
  ExcellCity({
    //ignore: non_constant_identifier_names
    this.location_id,
    this.location,
  });

  ExcellCity copyWith({
    //ignore: non_constant_identifier_names
    String location_id,
    String location,
  }) {
    return ExcellCity(
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

  static ExcellCity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ExcellCity(
      location_id: map['location_id'],
      location: map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  static ExcellCity fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Excellcity(location_id: $location_id, location: $location)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ExcellCity && o.location_id == location_id && o.location == location;
  }

  @override
  int get hashCode => location_id.hashCode ^ location.hashCode;
}
