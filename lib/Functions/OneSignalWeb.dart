import 'dart:async';
import 'dart:js' as js;
import 'dart:developer';

Future<String> getOneSignalPlayerId() async {
  // Initialize a variable to hold the OneSignal ID
  String oneSignalIdWeb = '';

  // Define the Dart callback function to be used by JavaScript
  js.context['dartCallback'] = (userId) {
    oneSignalIdWeb = userId ?? '';
    print('Web User ID: $oneSignalIdWeb');
  };

  try {
    // Execute JavaScript code to fetch the OneSignal User ID
    await js.context.callMethod('eval', [
      """
      (function() {
        return new Promise((resolve, reject) => {
          OneSignal.push(function() {
            OneSignal.getUserId(function(userId) {
              if (userId) {
                resolve(userId);
              } else {
                reject("User ID not found");
              }
            });
          });
        })
        .then(function(userId) {
          console.log("OneSignal User ID resolved: ", userId);
          window.dartCallback(userId); // Pass User ID to Dart
        })
        .catch(function(error) {
          console.error("OneSignal Error: ", error);
          window.dartCallback(null); // Pass null to Dart in case of error
        });
      })();
      """
    ]);

    // Wait until the callback updates the variable
    while (oneSignalIdWeb.isEmpty) {
      await Future.delayed(Duration(milliseconds: 100)); // Polling delay
    }
  } catch (error) {
    print('Error fetching OneSignal User ID: $error');
  }

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
