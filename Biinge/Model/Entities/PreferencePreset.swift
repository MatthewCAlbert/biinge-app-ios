//
//  PreferencePreset.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//

import Foundation

class PreferencePreset: BaseEntity {
    public let id: String?
    
    public var name: String?
    public var sessionLength: Int16 = 0
    
    required init() {
        self.id = nil
    }
    
    init(id: String?, name: String?, sessionLength: Int16) {
        self.id = id
        self.name = name
        self.sessionLength = sessionLength
    }
    
}
