import 'package:cloud_firestore/cloud_firestore.dart';

typedef ResponseBuilder<T> = T Function(dynamic);

mixin MbzModel<T> {
  String? docId;
  String? path;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool get withTimestamps => true;

  Map<String, dynamic> get toMap;

  DocumentReference? get documentReference => path == null ? null : FirebaseFirestore.instance.doc(path!);
}
