//
//  Delegates.swift
//  QwaryIos
//
//  Created by Geek Tech on 16/05/24.
//

import Foundation
import UIKit
public protocol QwaryInterface:AnyObject {
    func configure(context: UIViewController, qwSettings: String)
    func presentSurvey(fragmentActivity: UIViewController, isBanner: Bool)
    func addEvent(eventName: String)
    func logout()
    func dismissActiveSurvey()
}
protocol Callback {
    func qwMobileSdkReady(data: String)
    func qwSurveyHeight(data: String)
    func qwShow(data: String, isBanner: Bool)
    func qwEventTracking(data: String)
    func qwMobileLogout(data: String)
    func qwDismissSurvey(data: String)
}

public var Qwary:QwaryInterface = QwaryWebController()

