//
//  Icon.swift
//
//
//  Created by Kevin Hermawan on 07/10/23.
//

import Foundation

public struct Icon: Codable {
    public let label: String
    public let iconName: String
    public let isDefault: Bool
    
    public init(label: String, iconName: String, isDefault: Bool) {
        self.label = label
        self.iconName = iconName
        self.isDefault = isDefault
    }
}

extension Icon: Identifiable {
    public var id: String {
        iconName
    }
}
