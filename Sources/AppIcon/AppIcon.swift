//
//  AppIcon.swift
//
//
//  Created by Kevin Hermawan on 07/10/23.
//

import UIKit

public struct AppIcon {
    internal static var application: AppControllerProtocol = UIApplication.shared
    internal static var bundle: Bundle = .main
    
    public static var isSupported: Bool {
        application.supportsAlternateIcons
    }
    
    public static var current: Icon? {
        guard let currentIconName = application.alternateIconName else {
            return defined.first { $0.isDefault }
        }
        
        return defined.first { $0.iconName == currentIconName }
    }
    
    public static var defined: [Icon] {
        var icons: [Icon] = []
        
        guard let iconsDict = bundle.infoDictionary?["CFBundleIcons"] as? [String: Any] else {
            return icons
        }
        
        if let primaryIconDict = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
           let primaryIconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
           let primaryIconName = primaryIconFiles.first {
            let icon = Icon(key: "Default", label: "Default", iconName: primaryIconName, isDefault: true)
            
            icons.append(icon)
        }
        
        if let alternateIconsDict = iconsDict["CFBundleAlternateIcons"] as? [String: Any] {
            for (key, value) in alternateIconsDict {
                if let iconDict = value as? [String: Any],
                   let iconFiles = iconDict["CFBundleIconFiles"] as? [String],
                   let firstIconFile = iconFiles.first {
                    let label = generateLabel(from: key)
                    let icon = Icon(key: key, label: label, iconName: firstIconFile, isDefault: false)
                    
                    icons.append(icon)
                }
            }
        }
        
        let sortedIcons = icons
            .sorted {
                if $0.isDefault { return true }
                if $1.isDefault { return false }
                
                return $0.label.count < $1.label.count
            }
            .sorted { $0.label < $1.label }
        
        return sortedIcons
    }
    
    public static func set(to icon: Icon?, completion: ((Error?) -> Void)? = nil) {
        guard isSupported else {
            completion?(createError("Alternate icons not supported"))
            
            return
        }
        
        let iconName = icon?.isDefault ?? true ? nil : icon?.iconName
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            completion?(error)
        }
    }
    
    private static func generateLabel(from key: String) -> String {
        key.replacingOccurrences(of: "AppIcon-", with: "").replacingOccurrences(of: "-", with: " ")
    }
    
    private static func createError(_ message: String) -> NSError {
        NSError(domain: "AppIconError", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
