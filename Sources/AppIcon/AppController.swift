//
//  AppController.swift
//
//
//  Created by Kevin Hermawan on 07/10/23.
//

import UIKit

class AppController: AppControllerProtocol {
    var supportsAlternateIcons: Bool { return true }
    var alternateIconName: String? { return nil }
    
    func setAlternateIconName(_ alternateIconName: String?, completionHandler: ((Error?) -> Void)?) {}
}

protocol AppControllerProtocol {
    var supportsAlternateIcons: Bool { get }
    var alternateIconName: String? { get }
    
    func setAlternateIconName(_ alternateIconName: String?, completionHandler: ((Error?) -> Void)?)
}

extension UIApplication: AppControllerProtocol {
    
}
