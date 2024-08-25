import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobizleapps/model/firestore.dart';

abstract class MbzFirestoreFactory<T extends MbzFirestoreModel> {
  CollectionReference<T> get collectionReference;

  T? toModel(DocumentSnapshot<T> doc) {
    if (!doc.exists) {
      return null;
    }
    T? model = doc.data();
    if (model != null) {
      model.docId = doc.id;
      model.path = doc.reference.path;
      // model.createdAt = _createdTime?.toDate();
      //model.updatedAt = _updatedTime?.toDate();
    }
    return model;
  }

  Future<T?> create({String? docId, required T model}) async {
    if (docId != null) {
      return await collectionReference.doc(docId).set(model).then((value) async => await find(docId));
    }
    return await collectionReference.add(model).then((doc) async => toModel(await doc.get()));
  }

  Future<T?> find(String docId) async {
    return await collectionReference.doc(docId).get().then((doc) {
      return toModel(doc);
    });
  }

  Future<void> save({String? docId, SetOptions? setOptions, required T model}) async {
    if ((docId ?? model.docId) != null) {
      model.isUpdating = true;
    }
    return await collectionReference
        .doc(docId ?? model.docId)
        //.set(_dataMap(), setOptions)
        .set(model, setOptions)
        .then((value) => model.isUpdating = false);
  }

  Future<void> delete({String? docId, required T model}) async {
    print('delete object ${collectionReference.doc(docId ?? model.docId).path}');
    print('delete object ${model.path}');
    return await collectionReference.doc(docId ?? model.docId).delete();
  }
}
