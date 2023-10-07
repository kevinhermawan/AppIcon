//
//  Icon.swift
//
//
//  Created by Kevin Hermawan on 07/10/23.
//

import Foundation

public struct Icon {
    public let name: String
    public let imageName: String
    public let isDefault: Bool
    
    public init(name: String, imageName: String, isDefault: Bool) {
        self.name = name
        self.imageName = imageName
        self.isDefault = isDefault
    }
}
