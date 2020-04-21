import 'dart:convert';

class Ticket {
  final String id;
  final int cust_id;
  final int agent_area;
  final String status;
  final String created;
  final String updated;
  final int update_staff_id;
  final int staff_id;
  final int cust_location;
  final String tickettype;
  final String problem;
  Ticket({
    this.id,
    this.cust_id,
    this.agent_area,
    this.status,
    this.created,
    this.updated,
    this.update_staff_id,
    this.staff_id,
    this.cust_location,
    this.tickettype,
    this.problem,
  });

  Ticket copyWith({
    String id,
    int cust_id,
    int agent_area,
    String status,
    String created,
    String updated,
    int update_staff_id,
    int staff_id,
    int cust_location,
    String tickettype,
    String problem,
  }) {
    return Ticket(
      id: id ?? this.id,
      cust_id: cust_id ?? this.cust_id,
      agent_area: agent_area ?? this.agent_area,
      status: status ?? this.status,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      update_staff_id: update_staff_id ?? this.update_staff_id,
      staff_id: staff_id ?? this.staff_id,
      cust_location: cust_location ?? this.cust_location,
      tickettype: tickettype ?? this.tickettype,
      problem: problem ?? this.problem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cust_id': cust_id,
      'agent_area': agent_area,
      'status': status,
      'created': created,
      'updated': updated,
      'update_staff_id': update_staff_id,
      'staff_id': staff_id,
      'cust_location': cust_location,
      'tickettype': tickettype,
      'problem': problem,
    };
  }

  static Ticket fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Ticket(
      id: map['id'],
      cust_id: map['cust_id']?.toInt(),
      agent_area: map['agent_area']?.toInt(),
      status: map['status'],
      created: map['created'],
      updated: map['updated'],
      update_staff_id: map['update_staff_id']?.toInt(),
      staff_id: map['staff_id']?.toInt(),
      cust_location: map['cust_location']?.toInt(),
      tickettype: map['tickettype'],
      problem: map['problem'],
    );
  }

  String toJson() => json.encode(toMap());

  static Ticket fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Ticket(id: $id, cust_id: $cust_id, agent_area: $agent_area, status: $status, created: $created, updated: $updated, update_staff_id: $update_staff_id, staff_id: $staff_id, cust_location: $cust_location, tickettype: $tickettype, problem: $problem)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Ticket &&
      o.id == id &&
      o.cust_id == cust_id &&
      o.agent_area == agent_area &&
      o.status == status &&
      o.created == created &&
      o.updated == updated &&
      o.update_staff_id == update_staff_id &&
      o.staff_id == staff_id &&
      o.cust_location == cust_location &&
      o.tickettype == tickettype &&
      o.problem == problem;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      cust_id.hashCode ^
      agent_area.hashCode ^
      status.hashCode ^
      created.hashCode ^
      updated.hashCode ^
      update_staff_id.hashCode ^
      staff_id.hashCode ^
      cust_location.hashCode ^
      tickettype.hashCode ^
      problem.hashCode;
  }
}