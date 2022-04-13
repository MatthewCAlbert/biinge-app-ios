//
//  PointHistory.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//

import Foundation

enum PointActionType: String, CaseIterable {
    case restSuccess = "RestSuccess"
    case restSuccessStreak = "RestSuccessStreak"
}

class PointHistory: BaseEntity {
    public let id: String?
    
    public var action: PointActionType?
    public var amount: Int32 = 0
    public var createdAt: Date?
    
    required init() {
        self.id = nil
    }
    
    init(id: String?, action: String?, amount: Int32, createdAt: Date?) {
        self.id = id
        self.action = PointActionType(rawValue: action!) ?? nil
        self.amount = amount
        self.createdAt = createdAt
    }
    
}
