//
//  Session.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//

import Foundation

class Session: BaseEntity {
    public let id: String?
    
    public var start: Date?
    public var end: Date?
    public var targetEnd: Date?
    
    required init() {
        self.id = nil
    }
    
    init(id: String?, start: Date?, end: Date?, targetEnd: Date?) {
        self.id = id
        self.start = start
        self.end = end
        self.targetEnd = targetEnd
    }
    
}
