import 'dart:async';

import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v8.dart';

class EventController extends GetxController {
  static EventController get to => Get.find();

  EventHub _eventHub = EventHub();
  Map<String, StreamSubscription> streamSubscriptions = {};

  String subscribe(String eventName, void Function(dynamic) call) {
    String uid = Uuid().v8();
    streamSubscriptions[uid] = _eventHub.on(eventName, call);
    return uid;
  }

  void cancelSubscription(String uid) {
    streamSubscriptions[uid]?.cancel();
    streamSubscriptions.remove(uid);
  }

  void fire(String name, dynamic data) {
    _eventHub.fire(name, data);
  }
}
