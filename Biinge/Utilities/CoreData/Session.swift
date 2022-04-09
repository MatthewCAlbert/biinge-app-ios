//
//  Session.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import Foundation

class Session {
    let id: String = UUID().uuidString
    var start: Date
    var end: Date
    var targetEnd: Date
    
    init(_ start: Date, _ end: Date, _ targetEnd: Date) {
        self.start = start
        self.end = end
        self.targetEnd = targetEnd
    }
}
