//
//  Counter.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 12/04/22.
//

import Foundation
import Combine

class Counter {
    var publisher: AnyPublisher<Int, Never> {
        // Here we're "erasing" the information of which type
        // that our subject actually is, only letting our outside
        // code know that it's a read-only publisher:
        subject.eraseToAnyPublisher()
    }

    private(set) var value = 0 {
        didSet { subject.send(self.value) }
    }

    // By storing our subject in a private property, we'll only
    // be able to send new values to it from within this class:
    private let subject = PassthroughSubject<Int, Never>()

    func increment() {
        self.value += 1
    }
    
    init(_ value: Int) {
        self.value = value
    }
}
