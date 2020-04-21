import 'dart:convert';

class IssueType {
  final int id;
  final String messages;
  IssueType({
    this.id,
    this.messages,
  });

  IssueType copyWith({
    int id,
    String messages,
  }) {
    return IssueType(
      id: id ?? this.id,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messages': messages,
    };
  }

  static IssueType fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return IssueType(
      id: map['id']?.toInt(),
      messages: map['messages'],
    );
  }

  String toJson() => json.encode(toMap());

  static IssueType fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'IssueType(id: $id, messages: $messages)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is IssueType &&
      o.id == id &&
      o.messages == messages;
  }

  @override
  int get hashCode => id.hashCode ^ messages.hashCode;
}