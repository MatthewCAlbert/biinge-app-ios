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
    public var appSession: Date?
    public var streakCount: Int = 0
    
    required init() {
        self.id = nil
        self.appSession = nil
    }
    
    init(id: String?, start: Date?, end: Date?, targetEnd: Date?, appSession: Date? = Settings.shared.currentSessionStart, streakCount: Int = 0) {
        self.id = id
        self.start = start
        self.end = end
        self.targetEnd = targetEnd
        self.appSession = appSession
        self.streakCount = streakCount
    }
    
    func isObey() -> Bool? {
        if self.end == nil || self.targetEnd == nil {
            return nil
        }
        return !(self.end! as NSDate).isGreaterThanDate(dateToCompare: self.targetEnd! as NSDate)
    }
    
}
