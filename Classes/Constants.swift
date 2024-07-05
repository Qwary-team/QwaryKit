//
//  Constants.swift
//  QwaryKit
//
//  Created by Geek Tech on 05/07/24.
//

import Foundation
import WebKit

var jSpath = ""

//e.src = "\(srcroot)QwaryIos/qw.intercept.sdk.merged.js?id=" + app_id;
func getInitScript(appId: String) -> String
{
//    let srcroot = URL(fileURLWithPath: #file).deletingLastPathComponent()
//        .deletingLastPathComponent()
    var url = "https://static.qwary.com/resources/sdk/mobile_intercept/qw.intercept.sdk.js"
    return """
  var app_id = "\(appId)";
  window.qwSettings = {
    appId: "\(appId)",
    osPlatform: "iOS",
  };
   console.log = (function(oldLog) {
              return function(message) {
                  oldLog(message);
                          window.webkit.messageHandlers.qwSdkHook.postMessage(message);
              };
          })(console.log);
  
  !(function () {
    if (!window.qwTracking) {
      window.qwTracking = Object.assign({}, window.qwTracking, {
        queue:
          window.qwTracking && window.qwTracking.queue
            ? window.qwTracking.queue
            : [],
        track: function (t) {
          console.log("track");
          this.queue.push({ type: "track", props: t });
        },
        init: function (t) {
          console.log("init");
          this.queue.push({ type: "init", props: t });
        },
      });
      window.qwSettings;
      var t = function (t) {
        console.log("create",window?.qwSettings?.appId);
        var e = document.createElement("script");
        e.type = "text/javascript";
        e.async = true;
        e.src = "\(url)?id=" + app_id;
        var n = document.getElementsByTagName("script")[0];
        // Satinder Change as n is undefined  n.parentNode.insertBefore(e,n)
        document.head.appendChild(e);
      };
      if (document.readyState === "complete") {
        t();
      } else if (window.attachEvent) {
        window.attachEvent("onload", t);
      } else {
        window.addEventListener("load", t, false);
      }
    }
  })();
  qwTracking.init(qwSettings);
  """
}
func getEventTrackScript(eventName: String) -> String {
    return "qwTracking.track('\(eventName)');"
}

func getLogoutScript() -> String {
    return "qwTracking.logout();"
}
func executeJavascript(webView: WKWebView, javascript: String, callback: ((String?) -> Void)? = nil) {
    print("executeJavascript: \(javascript)")
    webView.evaluateJavaScript(javascript) { result, error in
        if let error = error {
            print("JavaScript execution error: \(error)")
            callback?(nil)
            return
        }
        if let resultString = result as? String {
            callback?(resultString)
        } else {
            callback?(nil)
        }
    }
}
extension Array {
    mutating func poll() -> Element? {
        return isEmpty ? nil : removeFirst()
    }
}

