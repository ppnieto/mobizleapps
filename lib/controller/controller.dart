import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobizleapps/controller/event.dart';

abstract class MbzController extends GetxController {
  final Map<String, StreamSubscription> _subscriptions = {};
  final List<String> _eventSubscriptions = [];

  Future<Map<String, Query>> getSubscriptionsQueries() async => {};

  void onSubscriptionUpdate(String subscription) {}

  Map<String, QuerySnapshot> snapshots = {};

  @override
  void onInit() {
    super.onInit();
    reloadSubscriptions();
  }

  void onEvent(String eventName, void Function(dynamic) call) {
    String id = Get.find<EventController>().subscribe(eventName, call);
    _eventSubscriptions.add(id);
  }

  void cancelSubscription(String uid) => Get.find<EventController>().cancelSubscription(uid);

  Future<void> reloadSubscriptions() async {
    _closeSubscriptions();
    Map<String, Query> queries = await getSubscriptionsQueries();
    for (var entry in queries.entries) {
      _subscriptions[entry.key] = entry.value.snapshots().listen((event) {
        snapshots[entry.key] = event;
        onSubscriptionUpdate(entry.key);
      });
    }
  }

  Future<void> reloadSubscription(String name) async {
    Map<String, Query> queries = await getSubscriptionsQueries();
    if (_subscriptions.containsKey(name) && queries.containsKey(name)) {
      var query = queries[name];
      _subscriptions[name]!.cancel();
      _subscriptions[name] = query!.snapshots().listen((event) {
        snapshots[name] = event;
        onSubscriptionUpdate(name);
      });
    } else {
      Get.log('GetxController::No puedo recargar suscripcion $name');
    }
  }

  void updateSubscription(String subscription, Query newQuery) {
    if (_subscriptions.containsKey(subscription)) {
      _subscriptions[subscription]!.cancel();
      _subscriptions[subscription] = newQuery.snapshots().listen((event) {
        snapshots[subscription] = event;
        onSubscriptionUpdate(subscription);
      });
    }
  }

  void _closeSubscriptions() {
    for (var entry in _subscriptions.entries) {
      entry.value.cancel();
    }
    _subscriptions.clear();
  }

  @override
  void onClose() {
    super.onClose();
    _closeSubscriptions();
  }
}
