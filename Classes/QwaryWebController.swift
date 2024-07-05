//
//  QwaryWebController.swift
//  QwaryIos
//
//  Created by Geek Tech on 28/06/24.
//

import Foundation
import UIKit
import WebKit
import JavaScriptCore

internal class QwaryWebController:NSObject, QwaryInterface, WKScriptMessageHandler {
    
    //static let shared = Qwary()
    var appID = ""
    var QW_SDK_HOOK = "qwSdkHook"
    var webFrame = CGRect()
    var webView = WKWebView()
    var alertController: UIAlertController!
    private weak var viewController: UIViewController?
    var rootPathUrl:URL?
    var delegate: Callback?
    
    var isSdkReady = false
    private var sdkReadyQueue: [String] = [String]()
    public override init() {
        super.init()
        self.delegate = self
    }
    //MARK: Functions for Implementation Qwary Interface
 
    func configure(context: UIViewController, qwSettings: String) {
        self.appID = qwSettings
        self.viewController = context
        
        let screenHeight = UIScreen.main.bounds.height
        var dynamicHeight = screenHeight / 3
        sdkReadyQueue.removeAll()
        // Add your custom view to the action sheet as well as WebView
        let customViewWidth = context.view.frame.width
        let frame = CGRect(x: 0, y: 0, width: customViewWidth - 12, height: dynamicHeight)
        // Made WKWebView Configuration
        let contentController = WKUserContentController()
        
        let webViewConfiguration = WKWebViewConfiguration()
        let webpagePreferences = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            webpagePreferences.allowsContentJavaScript = true
        } else {
            webpagePreferences.preferredContentMode
        }
        
        webViewConfiguration.defaultWebpagePreferences = webpagePreferences
        webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webViewConfiguration.userContentController = contentController
        webView = WKWebView(frame: frame,configuration: webViewConfiguration)
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: QW_SDK_HOOK)
        //webView.configuration.userContentController.add(CallBackInterface(delegate: self), name: QW_SDK_HOOK)
        let srcroot = URL(fileURLWithPath: #file).deletingLastPathComponent()
            .deletingLastPathComponent()
        rootPathUrl = URL(string: "\(srcroot)render.html")!
        if #available(iOS 14.0, *) {
            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript  = true
        } else {
            // Fallback on earlier versions
            webView.configuration.preferences.javaScriptEnabled = true
        }
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .black
        let url = URL(string: "\(srcroot)render.html")!
        loadHTMLPage()
        //getJSPath()
        //webView.loadFileURL(url, allowingReadAccessTo: url)
        
        
    }
    
    public func presentSurvey(fragmentActivity: UIViewController, isBanner: Bool) {
        if !isSdkReady{
            
            return
        }else{
            QwaryWebView.shared.showAlert(on: viewController!, title: "", message: "", shouldShowWebView: true, web: webView)
            if #available(iOS 15.0, *) {
                webView.underPageBackgroundColor = .clear
            } else {
                // Fallback on earlier versions
                webView.backgroundColor = .black
            }
        }
        
    }
    
    public func addEvent(eventName: String) {
        sdkReadyQueue.append(getEventTrackScript(eventName: eventName))
    }
    
    public func logout() {
        executeJavascript(getLogoutScript())
        //alertController.dismiss(animated: true)
    }
    
    public func dismissActiveSurvey() {
        print("Dismiss Active survey Called")
    }
    
    func executeJavascript(_ javascript: String, callback: ((String?) -> Void)? = nil) {
        webView.evaluateJavaScript(javascript) { (result, error) in
            if let error = error {
                //print("Error executing JavaScript: \(error.localizedDescription)")
                callback?(nil)
            } else if let result = result as? String {
                //print("JavaScript execution result: \(result)")
                
                callback?(result)
            } else {
                // Handle other result types if needed
                //print("JavaScript Call back nil")
                callback?(nil)
            }
        }
    }
    //Override Method gor WKscriptMessage Handler
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let messageBody = message.body as? [String: Any]{
            print("message Body: \(messageBody)")
        }
        if let dict = message.body as? [String:Any] {
            print("Returns from Dictionary cast \(dict)")
            return
        }
        guard let data = message.body as? String else {
            print("Returns from string cast")
            return
        }
        print("Continuess")
        print("data received \(data) with-- \(message.name) & Body --\(message.body)")
        switch data {
        case "qwMobileSdkReady":
            delegate?.qwMobileSdkReady(data:data )
        case "qwSurveyHeight":
            if let height = message.body as? String {
                            print("Received survey height: \(height)")
                            // Handle the height value as needed
            }
            delegate?.qwSurveyHeight(data: data)
            //        case "qwShow":
            //            print("Full Body \(message.body)")
            //            if let body = message.body as? [String:Any] {
            //                if let name = body["name"], let isTrue = body["isBanner"]{
            //                    print("qwShow is tracked")
            //                    delegate?.qwShow(data: name as! String, isBanner: isTrue as! Bool)
            //                }
            //
            //            }
        case "qwShow":
            delegate?.qwShow(data: data, isBanner: false)
        case "qwEventTracking":
            delegate?.qwEventTracking(data: data)
        case "qwMobileLogout":
            delegate?.qwMobileLogout(data: data)
        case "qwDismissSurvey":
            delegate?.qwDismissSurvey(data: data)
        case "CLOSE":
            QwaryWebView.shared.dismissAlert()
        case "SURVEY_COMPLETED":
            QwaryWebView.shared.dismissAlert()
            
        default:
            break
        }
        
    }
    
    //MARK: Get the Access of Html file
    private func loadHTMLPage(){
        let frameworkBundle = Bundle(for: type(of: self))
        
        if let htmlPath = frameworkBundle.path(forResource: "render", ofType: "html") {
            let localHTMLUrl = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
            
        }
        
    }
    
    //MARK: Get the Access of Javascript file
//    private func getJSPath(){
//        let frameworkBundle = Bundle(for: type(of: self))
//        if let jsFilePath = frameworkBundle.path(forResource: "qw.intercept.sdk.merged", ofType: "js") {
//            jSpath = jsFilePath
//
//        }
//    }
}
//MARK: Content Handler CallBacks from Qwary Web View
extension QwaryWebController:Callback{
    
    func qwMobileSdkReady(data: String) {
        print("From call back qwMobileSdkReady is called")
        isSdkReady = true
        while !sdkReadyQueue.isEmpty {
            print("data in sdkreadyQueue \(sdkReadyQueue),,,\(data)")
            if let script = sdkReadyQueue.poll() {
                executeJavascript(script)
            }
        }
    }
    
    func qwSurveyHeight(data: String) {
        print("Survey Height \(data)")
    }
    
    func qwShow(data: String, isBanner: Bool) {
        print("Call Back qwShow Func is called & alert Presented")
        QwaryWebView.shared.showAlert(on: viewController!, title: "", message: "", shouldShowWebView: true,web:webView)
        
    }
    func qwEventTracking(data: String) {
        print("Event Ttacking CallBack Function is Called")
    }
    func qwMobileLogout(data: String) {
        print("Logout Call Back Func Is Called \(data)")
    }
    
    func qwDismissSurvey(data: String) {
        if alertController.isBeingPresented == true{
            print("Alert Controller is dismissed")
            alertController.dismiss(animated: true)
        }
    }
    
    
}

extension QwaryWebController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript = getInitScript(appId: appID)
        executeJavascript(javascript)
        
    }
    
    
    
    
}

