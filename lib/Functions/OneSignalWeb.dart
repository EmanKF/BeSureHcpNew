import 'dart:async';
import 'dart:js' as js;
import 'dart:developer';

Future<String> getOneSignalPlayerId() async {
  // Initialize a variable to hold the OneSignal ID
  String oneSignalIdWeb = '';

  // Define the dartCallback function in Dart before calling JavaScript
  js.context['dartCallback'] = (userId) {
    // This callback will be called by JavaScript once the Promise is resolved
    oneSignalIdWeb = userId ?? '';
    print('webbbb: $oneSignalIdWeb');

  };

  try {
    // Execute the JavaScript code to get the OneSignal User ID
    await js.context.callMethod('eval', [
      """
      new Promise((resolve, reject) => {
        OneSignal.push(function() {
          OneSignal.getUserId(function(userId) {
            console.log("OneSignal User ID:", userId);
            if (userId) {
              resolve(userId);
            } else {
              reject("User ID not found");
            }
          });
        });
      }).then(function(userId) {
        console.log("Promise resolved with User ID: ", userId);
        window.dartCallback(userId); // Pass userId to Dart
        return userId;
      }).catch(function(error) {
        console.log("Promise rejected with error: ", error);
        window.dartCallback(null); // Call Dart with error if necessary
        throw error;
      });
      """
    ]);
    
    // Wait for the callback to set the OneSignal ID
    while (oneSignalIdWeb.isEmpty) {
      await Future.delayed(Duration(milliseconds: 100)); // Wait until the callback updates the variable
    }
  } catch (error) {
    log('Error: $error');
  }

  // Print and return the result after the Promise is resolved
  print('endd: $oneSignalIdWeb');
  return oneSignalIdWeb;
}

void loginWeb(String id) {
  // Call the OneSignal method to set external user ID
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
  // Call the OneSignal method to unsubscribe the user
  js.context.callMethod('eval', [
    """
    OneSignal.logout();
    """
  ]);
}
