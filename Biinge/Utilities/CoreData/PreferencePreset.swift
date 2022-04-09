//
//  PreferencePreset.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import Foundation

class PreferencePreset {
    
    let id: String = UUID().uuidString
    var name: String
    var sessionLength: Int
    
    init(_ name: String, _ length: Int ) {
        self.name = name
        self.sessionLength = length
    }
    
}
