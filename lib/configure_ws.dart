import 'dart:convert';
import 'dart:developer';

import 'package:besure_hcp/Functions/OneSignalWeb.dart';
import 'package:besure_hcp/RiverpodProviders/riverpodProviders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final websocketProvider = Provider<WebSocketService>((ref) {
  return WebSocketService();
});

class WebSocketService {
  WebSocketChannel? channel;

  // Public connect method
  Future<void> connect(WidgetRef ref) async {
    var onesignalId = '';
    if(kIsWeb){
      onesignalId = await getOneSignalPlayerId();
    }
    else{
      onesignalId = await OneSignal.User.getOnesignalId() ?? 'N/A';
    }
    log(onesignalId.toString()+' on connectig');
    if (channel != null) {
      log('WebSocket connection already established.');
      return;
    }
    log('Attempting to establish connection with WebSocket...');
    try {
      final prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('SPId') ?? '';

      if (id.isNotEmpty) {
        log('wss://api.esnadtakaful.com/api/ws?userId=$id');
        final url = 'wss://api.esnadtakaful.com/api/ws?userId=$id&deviceId=$onesignalId';
        print('Connecting to WebSocket at $url');
        channel = WebSocketChannel.connect(Uri.parse(url));
        log('WebSocket connected successfully.');

        // Listen for incoming messages
        channel!.stream.listen(
          (message) {
            log('WebSocket message received: $message');
            Map<String,dynamic> decodedMessage = jsonDecode(message);
            print(decodedMessage.toString());
            String action = decodedMessage['Action'] ?? '';
            
            if(action == 'ClientRequest'){
              Observable.instance.notifyObservers([
              "_TakeServicesScreenState",
              ], notifyName : "update",map: decodedMessage);
            }
            else if(action == 'PaymentFrontDesk'){
              Map map = Map();
              map['action'] = 'PaymentFrontDesk';
              map['lang'] = decodedMessage['LanguageId'];
              Observable.instance.notifyObservers([
              "_ConfirmServicesState",
              ], notifyName : "update",map: map);
            }
            else if(action == 'GeneratePaymentLink'){
              Map map = Map();
              map['action'] = 'GeneratePaymentLink';
              map['lang'] = decodedMessage['LanguageId'];
              Observable.instance.notifyObservers([
              "_ConfirmServicesState",
              ], notifyName : "update",map: map);
            }
            else if(action == "PaymentSuccess"){
              Map map = Map();
              map['action'] = 'PaymentSuccess';
              Observable.instance.notifyObservers([
              "_PayingDialogState",
              ], notifyName : "update",map: map);
            }
            else if(action == "PaymentFailed"){
              Map map = Map();
              map['action'] = 'PaymentFailed';
              Observable.instance.notifyObservers([
              "_PayingDialogState",
              ], notifyName : "update",map: map);
            }
          },
          onError: (error) {
            log('WebSocket error: $error');
          },
          onDone: () {
            log('WebSocket connection closed.');
            channel = null; // Reset channel to allow reconnection if needed
          },
        );
      } else {
        log('Unable to establish WebSocket connection: User ID is empty');
      }
    } catch (e) {
      log('Error connecting to WebSocket: $e');
    }
  }

  void sendMessage(String message) {
    if (channel != null) {
      log('Sending message: $message');
      channel!.sink.add(message);
    } else {
      log('WebSocket is not connected. Cannot send message.');
    }
  }

  void dispose(WidgetRef ref) {
    log('Closing WebSocket connection...');
    channel?.sink.close();
    channel = null; // Reset the channel to ensure it can reconnect later
  }
}
