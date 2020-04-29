import 'dart:convert';

class Location {
  final String location_id;
  final String location;
  final String contactnumber;
  final String sub_area;
  final List<dynamic> sub_areas_list;
  Location({
    this.location_id,
    this.location,
    this.contactnumber,
    this.sub_area,
    this.sub_areas_list,
  });

  Location copyWith({
    String location_id,
    String location,
    String contactnumber,
    String sub_area,
    String sub_areas_list,
  }) {
    return Location(
      location_id: location_id ?? this.location_id,
      location: location ?? this.location,
      contactnumber: contactnumber ?? this.contactnumber,
      sub_area: sub_area ?? this.sub_area,
      sub_areas_list: sub_areas_list ?? this.sub_areas_list,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location_id': location_id,
      'location': location,
      'contactnumber': contactnumber,
      'sub_area': sub_area,
      'sub_areas_list': sub_areas_list,
    };
  }

  static Location fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Location(
      location_id: map['location_id'],
      location: map['location'],
      contactnumber: map['contactnumber'],
      sub_area: map['sub_area'],
      sub_areas_list: map['sub_areas_list'],
    );
  }

  String toJson() => json.encode(toMap());

  static Location fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Location(location_id: $location_id, location: $location, contactnumber: $contactnumber, sub_area: $sub_area, sub_areas_list: $sub_areas_list)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Location &&
        o.location_id == location_id &&
        o.location == location &&
        o.contactnumber == contactnumber &&
        o.sub_area == sub_area &&
        o.sub_areas_list == sub_areas_list;
  }

  @override
  int get hashCode {
    return location_id.hashCode ^
        location.hashCode ^
        contactnumber.hashCode ^
        sub_area.hashCode ^
        sub_areas_list.hashCode;
  }
}

class SubArea {
  final String subarea_id;
  final String subarea_name;
  final String area_id;
  final String crm_id;

  SubArea(this.subarea_id, this.subarea_name, this.area_id, this.crm_id);
}
