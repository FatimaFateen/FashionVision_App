// ignore_for_file: public_member_api_docs, sort_constructors_first

class AppUser {
  final String username;
  final String uid;
  final String role;
  final int createdAt;
  final int tailorPrice;
  AppUser({
    required this.username,
    required this.uid,
    required this.role,
    required this.createdAt,
    required this.tailorPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'role': role,
      'createdAt': createdAt,
      'tailorPrice': tailorPrice,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      username: map['username'] as String,
      uid: map['uid'] as String,
      role: map['role'] as String,
      createdAt: map['createdAt'] as int,
      tailorPrice: map['tailorPrice'] as int,
    );
  }
}
