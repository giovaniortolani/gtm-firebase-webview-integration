// https://firebase.google.com/docs/analytics/webview

// This following code should be added in the webview before GTM loads (ideally) or before GTM + Firebase integration starts to fire events.
// It could be either:
//   - in the app code itself when it loads the webview (using some method like injectedJavaScriptBeforeContentLoaded for React Native) 
//   - or in a Custom HTML tag inside GTM (before GTM + Firebase integration starts to fire events).

// Examples of the configurations that must be done in the app itself for this integration to work. This will receive the data in the app and fire the events/commands from there:
// 
// - Native:
//   - iOS (option 1): https://github.com/xamarin/GoogleApisForiOSComponents/blob/main/docs/Firebase/Analytics/GettingStarted.md#implement-native-interface
//   - iOS (option 2): https://github.com/FirebaseExtended/analytics-webview/blob/c0b9a8037cb990f6d29050fbd827859a7851c527/ios/swift/FirebaseAnalyticsWeb/ViewController.swift
//   - Android: 
//     - https://github.com/FirebaseExtended/analytics-webview/blob/master/android/app/src/main/java/com/google/firebase/quickstart/analytics/webview/AnalyticsWebInterface.java
//     - or
//     - https://firebase.google.com/docs/analytics/webview?platform=android#implement_native_interface
// 
// - React Native:
//   - Message handler for both iOS and Android: https://github.com/react-native-webview/react-native-webview/blob/master/docs/Guide.md#the-windowreactnativewebviewpostmessage-method-and-onmessage-prop

var firebaseAnalyticsInterface = {
  logEvent: function logEvent(name, params) {
    // debugger;
    if (!name) {
      return;
    }

    if (window.AnalyticsWebInterface) {
      // Call Android interface
      window.AnalyticsWebInterface.logEvent(name, JSON.stringify(params));
    } else if (window.webkit
        && window.webkit.messageHandlers
        && window.webkit.messageHandlers.firebase) {
      // Call iOS interface
      var message = {
        command: 'logEvent',
        name: name,
        parameters: params
      };
      window.webkit.messageHandlers.firebase.postMessage(message);
    } else {
      // No Android or iOS interface found
      console.log("No native APIs found.");
    }
  },

  setUserProperty: function setUserProperty(name, value) {
    // debugger;
    if (!name || !value) {
      return;
    }

    if (window.AnalyticsWebInterface) {
      // Call Android interface
      window.AnalyticsWebInterface.setUserProperty(name, value);
    } else if (window.webkit
        && window.webkit.messageHandlers
        && window.webkit.messageHandlers.firebase) {
      // Call iOS interface
      var message = {
        command: 'setUserProperty',
        name: name,
        value: value
      };
      window.webkit.messageHandlers.firebase.postMessage(message);
    } else {
      // No Android or iOS interface found
      console.log("No native APIs found.");
    }
  },

  setDefaultEventParameters: function setDefaultEventParameters(params) {
    // debugger; 
    if (!params) {
      return;
    }

    if (window.AnalyticsWebInterface) {
      // Call Android interface
      window.AnalyticsWebInterface.setDefaultEventParameters(JSON.stringify(params));
    } else if (window.webkit
        && window.webkit.messageHandlers
        && window.webkit.messageHandlers.firebase) {
      // Call iOS interface
      var message = {
        command: 'setDefaultEventParameters',
        parameters: params
      };
      window.webkit.messageHandlers.firebase.postMessage(message);
    } else {
      // No Android or iOS interface found
      console.log("No native APIs found.");
    }
  },

  setUserId: function setUserId(userId) {
    // debugger;
    if (!userId) {
      return;
    }

    if (window.AnalyticsWebInterface) {
      // Call Android interface
      window.AnalyticsWebInterface.setUserId(userId);
    } else if (window.webkit
        && window.webkit.messageHandlers
        && window.webkit.messageHandlers.firebase) {
      // Call iOS interface
      var message = {
        command: 'setUserId',
        userId: userId,
      };
      window.webkit.messageHandlers.firebase.postMessage(message);
    } else {
      // No Android or iOS interface found
      console.log("No native APIs found.");
    }
  },

  setAnalyticsCollectionEnabled: function setAnalyticsCollectionEnabled(enabled) {
    if (typeof enabled !== 'boolean') {
      return;
    }

    // ...
  },

  resetAnalyticsData: function resetAnalyticsData() {
    // ...
  },

  getAppInstanceId: function getAppInstanceId() {
    // ...
  },

  getSessionId: function getSessionId() {
    // ...
  },

  setConsent: function setConsent(consentSettings) {
    if (!consentSettings) {
      return
    }
    // ...
  }
};
