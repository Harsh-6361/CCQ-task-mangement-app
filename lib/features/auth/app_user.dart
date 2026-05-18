import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    @Default('user') String role, // 'admin' or 'user'
    @Default({
      'tasks': true,
      'crm': true,
      'teams': true,
      'calendar': true,
    }) Map<String, bool> permissions,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromJson({
      ...data,
      'uid': doc.id,
    });
  }
}
