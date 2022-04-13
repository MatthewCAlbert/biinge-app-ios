//
//  PointHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation

struct PointReward {
    static let restSuccess = 5
    static let restSuccessStreak = 10
}


class PointHelper {
    
    static let shared = PointHelper()
    let pointHistoryRepository = PointHistoryRepository.shared
    
    private init() {
    }
    
    func addPoints(action: PointActionType) throws {
        let newHistory = PointHistory()
        switch action {
            case .restSuccess:
                newHistory.amount = Int32(PointReward.restSuccess)
            case .restSuccessStreak:
                newHistory.amount = Int32(PointReward.restSuccessStreak)
        }
        newHistory.createdAt = Date()
        newHistory.action = action
        
        _ = try pointHistoryRepository.create(newHistory)
        UserProfile.shared.addPoints(PointReward.restSuccess)
    }
    
}
