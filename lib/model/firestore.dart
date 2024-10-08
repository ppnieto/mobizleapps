import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobizleapps/model/model.dart';

abstract class MbzFirestoreModel<T extends MbzModel> with MbzModel<T> {
  //CollectionReference get _collectionReference => _initReference();
  bool isUpdating = false;

  MbzFirestoreModel() {
    createdAt = DateTime.now();
  }

  MbzFirestoreModel.fromSnapshot(DocumentSnapshot doc) {
    docId = doc.id;
    path = doc.reference.path;
  }

  //CollectionReference get collectionReference;

  //String get collectionName;
  //T fromSnapshot(DocumentSnapshot doc);
/*
  _initReference() {
    return FirebaseFirestore.instance.collection(this.collectionName).withConverter(
        fromFirestore: (snapshot, _) => fromSnapshot(snapshot), toFirestore: (snapshot, _) => _dataMap());
  }
  */

/*
  _responseBuilder(Map<String, dynamic>? map) {
    this._createdTime = map?['createdAt'];
    this._updatedTime = map?['updatedAt'];
    return this.responseBuilder(map);
  }
*/

/*
  Map<String, dynamic> _dataMap({Map<String, dynamic>? map}) {
    Map<String, dynamic> data = <String, dynamic>{};
    data.addAll(map ?? toMap);
    if (withTimestamps) {
      data.addAll({
        isUpdating ? 'updatedAt' : 'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return data;
  }
*/
  //ResponseBuilder<T> get responseBuilder;
}
