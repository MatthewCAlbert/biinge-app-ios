//
//  AVHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation
import AVKit
import AVFoundation

class AVHelper {
    
    static let shared = AVHelper()
    private var avPlayer: AVPlayer?
    
    private init() {
        self.setup()
    }
    
    private func setup() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.avPlayer = AVPlayer()
    }
    
    func start() {
        guard let player = avPlayer else {
            self.setup()
            return
        }
        player.play()
    }
    
    func end() {
        guard let player = avPlayer else {
            self.setup()
            return
        }
        player.pause()
    }
    
}
