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
        subject.eraseToAnyPublisher()
    }

    private(set) var value = 0 {
        didSet { subject.send(self.value) }
    }

    private let subject = PassthroughSubject<Int, Never>()
    private var isPaused = false
    
    private var timer = Timer()
    init(_ value: Int = 0) {
        self.value = value
    }
    
    func setCurrentTime(_ value: Int) {
        self.value = value
    }
    
    func start(_ value: Int = 0) {
        timer.invalidate()
        self.value = value
        
        // Start another timer
        self.resume()
    }
    
    func resume() {
        self.isPaused = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func pause() {
        timer.invalidate()
        self.isPaused = true
    }
    
    func end() {
        timer.invalidate()
    }
    
    func end(value: Int) {
        self.value = value
        timer.invalidate()
    }
    
    @objc func updateCounter() {
        if !self.isPaused {
            self.value += 1
        }
    }
}
