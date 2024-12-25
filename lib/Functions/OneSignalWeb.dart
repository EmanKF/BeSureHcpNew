import 'dart:async';
import 'dart:js' as js;
import 'dart:developer';

Future<String> getOneSignalPlayerId() async {
  // Completer to allow returning a value asynchronously
  // Completer<String> completer = Completer<String>();

  // Call the JavaScript code to fetch the OneSignal Player ID
  try {
    final result = await js.context.callMethod('eval', [
      """
      new Promise((resolve, reject) => {
        OneSignal.push(function() {
          OneSignal.getUserId(function(userId) {
            console.log("OneSignal User ID:", userId);
            if (userId) {
              resolve(userId);
              OneSignal.setExternalUserId(userId);
            } else {
              reject("User ID not found");
            }
          });
        });
      });
      """
    ]);

    if (result is js.JsObject) {
      log(result.toString());
      print(result.toString());
      // If the result is a JsObject, extract the userId
      return result['userId'] ?? 'No User ID';  // Return the userId if available
    } else {
      return result.toString();  // Otherwise, just convert it to string
    }
  } catch (e) {
    print("Error occurred while getting the user ID: $e");
    return 'Error';  // Handle errors gracefully
  }
}

void loginWeb(id){
  js.context.callMethod('eval', [
      """
      OneSignal.push(function() {
        console.log('Setting external user ID:', '$id');
        OneSignal.setExternalUserId('$id');
      });
      """
    ]);
}

void logoutFromOneSignal() {
  // Call the JavaScript method to set subscription to false (unsubscribe the user)
  js.context.callMethod('eval', [
    """
    OneSignal.setSubscription(false);
    """
  ]);
}