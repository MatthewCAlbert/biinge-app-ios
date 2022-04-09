//
//  PointHistory.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import Foundation

enum PointActionType: String, CaseIterable {
    case restSuccess = "RestSuccess"
    case dailyTargetSuccess =  "DailyTargetSuccess"
}

class PointHistory {
    
    let id: String = UUID().uuidString
    let createdAt: Date = Date()
    var action: PointActionType
    var amount: Int
    
    init( _ action: PointActionType, _ amount: Int ) {
        self.action = action
        self.amount = amount
    }
    
}
