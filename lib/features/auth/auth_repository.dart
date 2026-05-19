import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _syncUserToFirestore();
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _syncUserToFirestore();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _syncUserToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'role': 'user',
        'permissions': {
          'tasks': true,
          'crm': true,
          'teams': true,
          'calendar': true,
        },
      });
    }
  }

  Stream<AppUser?> watchUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
          (doc) => doc.exists ? AppUser.fromFirestore(doc) : null,
        );
  }

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<List<AppUser>> getUsersByIds(List<String> uids) async {
    final List<AppUser> users = [];
    for (final uid in uids) {
      final user = await getUserProfile(uid);
      if (user != null) users.add(user);
    }
    return users;
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
}

@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

@riverpod
String? userId(Ref ref) {
  return ref.watch(authStateProvider).value?.uid;
}

@riverpod
Stream<AppUser?> currentUserProfile(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(authRepositoryProvider).watchUserProfile(uid);
}

@riverpod
Future<AppUser?> userProfile(Ref ref, String uid) {
  return ref.watch(authRepositoryProvider).getUserProfile(uid);
}

@riverpod
Future<List<AppUser>> usersByIds(Ref ref, List<String> uids) {
  return ref.watch(authRepositoryProvider).getUsersByIds(uids);
}

// MASQUERADE CONTEXT
@riverpod
class ActiveUserContext extends _$ActiveUserContext {
  @override
  String? build() {
    return ref.watch(userIdProvider);
  }

  void actAs(String targetUid) {
    state = targetUid;
  }

  void reset() {
    state = ref.read(userIdProvider);
  }
}
