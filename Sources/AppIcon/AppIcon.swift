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
        public let isDefault: Bool
    }
    
    public static var isSupported: Bool {
        application.supportsAlternateIcons
    }
    
    public static var current: Icon? {
        guard let currentIconName = application.alternateIconName else {
            return defined.first { $0.isDefault }
        }
        
        return defined.first { $0.name == currentIconName }
    }
    
    public static var defined: [Icon] {
        var icons: [Icon] = []
        
        guard let iconsDict = bundle.infoDictionary?["CFBundleIcons"] as? [String: Any] else {
            return icons
        }
        
        if let primaryIconDict = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
           let primaryIconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
           let primaryIconName = primaryIconFiles.first {
            icons.append(Icon(name: "Default", imageName: primaryIconName, isDefault: true))
        }
        
        if let alternateIconsDict = iconsDict["CFBundleAlternateIcons"] as? [String: Any] {
            for (key, value) in alternateIconsDict {
                if let iconDict = value as? [String: Any],
                   let iconFiles = iconDict["CFBundleIconFiles"] as? [String],
                   let firstIconFile = iconFiles.first {
                    icons.append(Icon(name: key, imageName: firstIconFile, isDefault: false))
                }
            }
        }
        
        let sortedIcons = icons
            .sorted {
                if $0.isDefault { return true }
                if $1.isDefault { return false }
                
                return $0.name.count < $1.name.count
            }
            .sorted { $0.name < $1.name }
        
        return sortedIcons
    }
    
    public static func set(icon: Icon?, completion: ((Error?) -> Void)? = nil) {
        guard isSupported else {
            completion?(createError("Alternate icons not supported"))
            
            return
        }
        
        let iconName = icon?.isDefault ?? true ? nil : icon?.imageName
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            completion?(error)
        }
    }
    
    private static func createError(_ message: String) -> NSError {
        NSError(domain: "AppIconError", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
