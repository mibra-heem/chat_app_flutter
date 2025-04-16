import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';

class DashboardUtils {
  DashboardUtils._();

  static Stream<LocalUserModel> get userDataStream => sl<FirebaseFirestore>()
  .collection('users')
  .doc(sl<FirebaseAuth>().currentUser!.uid)
  .snapshots()
  .map((e) => LocalUserModel.fromMap(e.data()!)); 
}
