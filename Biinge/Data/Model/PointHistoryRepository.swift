//
//  PointHistoryRepository.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import Foundation

class PointHistoryRepository {
    
    var coreDataStore: SeederCoreDataStore
    
    var pointHistories: [PointHistory]?
    
    func getPointHistories() -> [PointHistory] {
        if self.pointHistories == nil {
            // add data here
            self.pointHistories = [PointHistory]()
        }
        
        return self.pointHistories!
    }
    
    func add(_ pointHistory: PointHistory) {
        pointHistories?.append(pointHistory)
    }

    func update(_ pointHistory: PointHistory) {
        guard let index = pointHistories?.firstIndex(where: { $0.id == pointHistory.id }) else { return }
        pointHistories?[index] = pointHistory
    }
    
    static let shared = PointHistoryRepository(SeederCoreDataStore())
    
    private init(_ coreDataStore: SeederCoreDataStore) {
        self.coreDataStore = coreDataStore
    }
    
}
