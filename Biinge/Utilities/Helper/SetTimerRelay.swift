//
//  SetTimerRelay.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 14/04/22.
//

import Foundation
import Combine

struct SetTimerRelayMessage {
    var breakTimerLimitSeconds: Int = 0
    var sessionTimerLimitSeconds: Int = 0
    var watchReminderLabel: String = ""
    var breakReminderLabel: String = ""
}

class SetTimerRelay {
    
    static let shared = SetTimerRelay()
    
    var publisher: AnyPublisher<SetTimerRelayMessage, Never> {
        publishedSubject.eraseToAnyPublisher()
    }
    var sessionMessage = SetTimerRelayMessage() {
        didSet { publishedSubject.send(self.sessionMessage) }
    }
    private let publishedSubject = PassthroughSubject<SetTimerRelayMessage, Never>()
    
    private init() {
        self.sessionMessage.watchReminderLabel = ""
        self.sessionMessage.breakReminderLabel = ""
        self.sessionMessage.breakTimerLimitSeconds = Settings.shared.targetRestInMinute * 60
        self.sessionMessage.sessionTimerLimitSeconds = Settings.shared.sessionLengthInMinute * 60
    }
    
}
