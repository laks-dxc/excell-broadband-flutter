import 'dart:convert';

class BBPlan {
  final String plan_id;
  final String plan_name;
  final String plan_type;
  final String plantype_name;
  final String plan_speed;
  final String data_limit;
  final String plan_postfup;
  final String plan_amount;
  final String location_id;
  final String location;
  final String contactnumber;
  final String address;
  final String emailid;
  BBPlan({
    this.plan_id,
    this.plan_name,
    this.plan_type,
    this.plantype_name,
    this.plan_speed,
    this.data_limit,
    this.plan_postfup,
    this.plan_amount,
    this.location_id,
    this.location,
    this.contactnumber,
    this.address,
    this.emailid,
  });

  BBPlan copyWith({
    String plan_id,
    String plan_name,
    String plan_type,
    String plantype_name,
    String plan_speed,
    String data_limit,
    String plan_postfup,
    String plan_amount,
    String location_id,
    String location,
    String contactnumber,
    String address,
    String emailid,
  }) {
    return BBPlan(
      plan_id: plan_id ?? this.plan_id,
      plan_name: plan_name ?? this.plan_name,
      plan_type: plan_type ?? this.plan_type,
      plantype_name: plantype_name ?? this.plantype_name,
      plan_speed: plan_speed ?? this.plan_speed,
      data_limit: data_limit ?? this.data_limit,
      plan_postfup: plan_postfup ?? this.plan_postfup,
      plan_amount: plan_amount ?? this.plan_amount,
      location_id: location_id ?? this.location_id,
      location: location ?? this.location,
      contactnumber: contactnumber ?? this.contactnumber,
      address: address ?? this.address,
      emailid: emailid ?? this.emailid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plan_id': plan_id,
      'plan_name': plan_name,
      'plan_type': plan_type,
      'plantype_name': plantype_name,
      'plan_speed': plan_speed,
      'data_limit': data_limit,
      'plan_postfup': plan_postfup,
      'plan_amount': plan_amount,
      'location_id': location_id,
      'location': location,
      'contactnumber': contactnumber,
      'address': address,
      'emailid': emailid,
    };
  }

  static BBPlan fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return BBPlan(
      plan_id: map['plan_id'],
      plan_name: map['plan_name'],
      plan_type: map['plan_type'],
      plantype_name: map['plantype_name'],
      plan_speed: map['plan_speed'],
      data_limit: map['data_limit'],
      plan_postfup: map['plan_postfup'],
      plan_amount: map['plan_amount'],
      location_id: map['location_id'],
      location: map['location'],
      contactnumber: map['contactnumber'],
      address: map['address'],
      emailid: map['emailid'],
    );
  }

  String toJson() => json.encode(toMap());

  static BBPlan fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'BBPlans(plan_id: $plan_id, plan_name: $plan_name, plan_type: $plan_type, plantype_name: $plantype_name, plan_speed: $plan_speed, data_limit: $data_limit, plan_postfup: $plan_postfup, plan_amount: $plan_amount, location_id: $location_id, location: $location, contactnumber: $contactnumber, address: $address, emailid: $emailid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is BBPlan &&
      o.plan_id == plan_id &&
      o.plan_name == plan_name &&
      o.plan_type == plan_type &&
      o.plantype_name == plantype_name &&
      o.plan_speed == plan_speed &&
      o.data_limit == data_limit &&
      o.plan_postfup == plan_postfup &&
      o.plan_amount == plan_amount &&
      o.location_id == location_id &&
      o.location == location &&
      o.contactnumber == contactnumber &&
      o.address == address &&
      o.emailid == emailid;
  }

  @override
  int get hashCode {
    return plan_id.hashCode ^
      plan_name.hashCode ^
      plan_type.hashCode ^
      plantype_name.hashCode ^
      plan_speed.hashCode ^
      data_limit.hashCode ^
      plan_postfup.hashCode ^
      plan_amount.hashCode ^
      location_id.hashCode ^
      location.hashCode ^
      contactnumber.hashCode ^
      address.hashCode ^
      emailid.hashCode;
  }
}