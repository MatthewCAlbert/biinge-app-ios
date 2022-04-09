//
//  SessionRepository.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import UIKit

class SessionRepository {
    
    var coreDataStore: SeederCoreDataStore
    
    var sessions: [Session]?
    
    func getSessions() -> [Session] {
        if self.sessions == nil {
            // add data here
            self.sessions = [Session]()
        }
        
        return self.sessions!
    }
    
    func add(_ session: Session) {
        sessions?.append(session)
    }

    func update(_ session: Session) {
        guard let index = sessions?.firstIndex(where: { $0.id == session.id }) else { return }
        sessions?[index] = session
    }
    
    static let shared = SessionRepository(SeederCoreDataStore())
    
    private init(_ coreDataStore: SeederCoreDataStore) {
        self.coreDataStore = coreDataStore
    }
    
}
