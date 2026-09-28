import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/error/exception_mapper.dart';
import '../domain/entities/inbox_entry.dart';
import 'inbox_dto.dart';

class InboxRepository {
  InboxRepository({required this.uid, FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users/$uid/automation_inbox');

  Stream<List<InboxEntry>> watchInbox() {
    return _collection.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(InboxDto.fromSnapshot).toList(),
        );
  }

  /// Removes an inbox entry once it's been committed to a real transaction,
  /// or discarded by the user.
  Future<void> discard(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
