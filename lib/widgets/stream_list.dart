import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobizleapps/widgets/loading.dart';
import 'package:mobizleapps/widgets/no_elements.dart';

class MbzStreamList extends StatelessWidget {
  final String? noElementTitle;
  final Widget? noElementWidget;
  final Query query;
  final bool useColumn;
  final Widget Function(DocumentSnapshot doc) builder;
  const MbzStreamList(
      {super.key,
      required this.query,
      required this.builder,
      this.noElementTitle,
      this.noElementWidget,
      this.useColumn = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) return MbzLoading();
        if (snapshot.data!.docs.isEmpty) {
          return noElementWidget ?? MbzNoElements(title: noElementTitle ?? "No hay datos que mostrar");
        }

        if (useColumn) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data!.docs.map((e) => builder(e)).toList());
        } else {
          return ListView(children: snapshot.data!.docs.map((e) => builder(e)).toList());
        }
      },
    );
  }
}
