import 'dart:async';
import 'dart:js' as js;

Future<String> getOneSignalPlayerId() async {
  // Completer to allow returning a value asynchronously
  Completer<String> completer = Completer<String>();

  // Call the JavaScript code to fetch the OneSignal Player ID
  js.context.callMethod('eval', [
    """
    OneSignal.push(function() {
      OneSignal.getUserId(function(playerId) {
        // If playerId is available, resolve the completer
        if (playerId) {
          window.dispatchEvent(new CustomEvent('playerIdReceived', {detail: playerId}));
        } else {
          window.dispatchEvent(new CustomEvent('playerIdReceived', {detail: ''}));
        }
      });
    });
    """
  ]);

  // Listen for the custom event in JavaScript and return the playerId to Dart
  js.context['window'].addEventListener('playerIdReceived', js.allowInterop((event) {
    String playerId = event['detail'];
    if (!completer.isCompleted) {
      completer.complete(playerId); // Complete the Future with the player ID
    }
  }));

  // Return the Future that will be completed with the player ID
  return completer.future;
}