//
//  CallAudio.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import AVFoundation

class CallAudio {
    
    static func configureAudioSession() {
        print("Configuring audio session")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
        } catch (let error) {
            print("Error while configuring audio session: \(error)")
        }
    }

    static func startAudio() {
        print("Starting audio")
    }

    static func stopAudio() {
        print("Stopping audio")
    }

}
