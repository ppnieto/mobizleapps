import 'package:cloud_firestore/cloud_firestore.dart';

class MbzQuery {
  final String name;
  final Query query;
  String? dependency;

  MbzQuery({required this.name, required this.query, this.dependency});
}
