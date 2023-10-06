//
//  AppController.swift
//
//
//  Created by Kevin Hermawan on 07/10/23.
//

import UIKit

class AppController {
    var supportsAlternateIcons: Bool {
        UIApplication.shared.supportsAlternateIcons
    }
    
    var alternateIconName: String? {
        UIApplication.shared.alternateIconName
    }
    
    func setAlternateIconName(_ alternateIconName: String?, completionHandler: ((Error?) -> Void)?) {
        UIApplication.shared.setAlternateIconName(alternateIconName, completionHandler: completionHandler)
    }
}
