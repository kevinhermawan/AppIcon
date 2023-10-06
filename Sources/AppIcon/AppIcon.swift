//
//  AppIcon.swift
//
//
//  Created by Kevin Hermawan on 07/10/23.
//

import UIKit

public struct AppIcon {
    internal static var application: AppController = AppController()
    internal static var bundle: Bundle = .main

    public struct Icon {
        public let name: String
        public let imageName: String
    }
    
    public static var isSupported: Bool {
        application.supportsAlternateIcons
    }
    
    public static var current: String? {
        application.alternateIconName
    }
    
    public static var defined: [Icon] {
        var icons: [Icon] = []
        
        guard let iconsDict = bundle.infoDictionary?["CFBundleIcons"] as? [String: Any] else {
            return icons
        }
        
        if let primaryIconDict = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
           let primaryIconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
           let primaryIconName = primaryIconFiles.first {
            icons.append(Icon(name: "Default", imageName: primaryIconName))
        }
        
        if let alternateIconsDict = iconsDict["CFBundleAlternateIcons"] as? [String: Any] {
            for (key, value) in alternateIconsDict {
                if let iconDict = value as? [String: Any],
                   let iconFiles = iconDict["CFBundleIconFiles"] as? [String],
                   let firstIconFile = iconFiles.first {
                    icons.append(Icon(name: key, imageName: firstIconFile))
                }
            }
        }
        
        return icons
    }
    
    public static func set(name iconName: String?, completion: ((Error?) -> Void)? = nil) {
        guard isSupported else {
            completion?(createError("Alternate icons not supported"))
            
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconName, completionHandler: { error in
            completion?(error)
        })
    }
    
    private static func createError(_ message: String) -> NSError {
        NSError(domain: "AppIconError", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
