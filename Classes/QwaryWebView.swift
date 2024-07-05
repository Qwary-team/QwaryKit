import Foundation
import UIKit
import WebKit

class QwaryWebView {

    private var alertController: UIAlertController = UIAlertController()
    static let shared = QwaryWebView()
    
    func showAlert(on viewController: UIViewController,
                   title: String,
                   message: String,
                   shouldShowWebView: Bool,
                   web: WKWebView) {
        if shouldShowWebView{
            alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            //Calculate the Frame data
            let screenHeight = UIScreen.main.bounds.height
            let height  = screenHeight / 3
            let customViewWidth = UIScreen.main.bounds.width
            var frame = CGRect()
            let cView = UIView()
            
            cView.backgroundColor = UIColor.white
            //if #available(iOS 16.0, *) {
                if screenHeight > 750 {
                
                frame = CGRect(x: 0, y: 0, width: customViewWidth - 12, height: height - 15 )
                cView.frame = CGRect(x: 0, y: 0, width: customViewWidth - 12, height: height)
            } else {
                // Fallback on earlier versions
                frame = CGRect(x: 0, y: 0, width: customViewWidth - 12, height: 267 )
                cView.frame = CGRect(x: 0, y: 0, width: customViewWidth - 12, height: 290 )
            }
            web.frame = frame
            let dismissAction1 = UIAlertAction(title: "", style: .default, handler: nil)
            let dismissAction2 = UIAlertAction(title: "", style: .default, handler: nil)
            let dismissAction3 = UIAlertAction(title: "", style: .default, handler: nil)
            let dismissAction = UIAlertAction(title: "", style: .cancel, handler: nil)
            alertController.addAction(dismissAction1)
            alertController.addAction(dismissAction2)
            alertController.addAction(dismissAction3)
            alertController.addAction(dismissAction)
            alertController.view.addSubview(cView)
            alertController.view.addSubview(web)
            //alertController.view.backgroundColor = UIColor.clear
            if UIDevice.current.userInterfaceIdiom == .pad {
                // If it's an iPad, present the action sheet using a popover presentation controller
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = viewController.view // Set the source view
                    popoverController.sourceRect = CGRect(x: 0, y: 0, width: customViewWidth, height: height/3) // Set the source rect
                    // You can also set popoverController.barButtonItem if you're presenting from a bar button item
                }
            }
            viewController.present(alertController, animated: true, completion: nil)
        }
        
   
        
    }
    
    func dismissAlert() {
        alertController.dismiss(animated: true, completion: nil)
    }
}
