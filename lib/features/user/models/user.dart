import 'dart:convert';

class GChatUser {
  String uid;
  String name;
  String email;

  GChatUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  GChatUser copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return GChatUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory GChatUser.fromMap(Map<String, dynamic> map) {
    return GChatUser(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GChatUser.fromJson(String source) =>
      GChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GChatUser(uid: $uid, name: $name, email: $email)';

  @override
  bool operator ==(covariant GChatUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.name == name && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ email.hashCode;
}
