//
//  ProviderDelegate.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation
import AVFoundation
import CallKit
import UIKit

class ProviderDelegate: NSObject {
    
    private let callManager: CallManager
    private let provider: CXProvider

    init(callManager: CallManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
        
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    static var providerConfiguration: CXProviderConfiguration = {
        let providerConfiguration = CXProviderConfiguration()
        
        providerConfiguration.iconTemplateImageData = UIImage(named: "AppIcon")?.pngData()
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallGroups = 1
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.includesCallsInRecents = false
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        return providerConfiguration
    }()

    func reportIncomingCall(
        uuid: UUID,
        handle: String,
        completion: ((Error?) -> Void)?
    ) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                let call = Call(uuid: uuid, handle: handle)
                self.callManager.add(call: call)
            }
            completion?(error)
        }
    }
    
}

// MARK: - CXProviderDelegate
extension ProviderDelegate: CXProviderDelegate {
    
    // on reset
    func providerDidReset(_ provider: CXProvider) {
        print("action: call reset")
        CallAudio.stopAudio()

        for call in callManager.calls {
          call.end()
        }
        
        callManager.removeAllCalls()
    }

    // on connected
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("action: call starting")
        CallAudio.startAudio()
        CallHelper.shared.callStateConnected = true
    }

    // on ended (rejected / missed)
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
          action.fail()
          return
        }
        print("action: call ended")
        CallAudio.stopAudio()
        
        call.end()

        action.fulfill()

        callManager.remove(call: call)
        
        if CallHelper.shared.callStateConnected {
            CallHelper.shared.onSuccessToAnswer()
        } else {
            CallHelper.shared.onFailedToAnswer()
        }
    }
      
    
    // MARK: unused below here
    
    // on answered outgoing
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        CallAudio.configureAudioSession()

        call.answer()

        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
              action.fail()
              return
            }
        
        call.state = action.isOnHold ? .held : .active
        
        if call.state == .held {
            print("action: call held")
            CallAudio.stopAudio()
        } else {
            print("action: call resumed")
            CallAudio.startAudio()
            // will continue to -> call starting
        }
        
        action.fulfill()
    }
      
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("action: start outgoing call")
        let call = Call(uuid: action.callUUID, outgoing: true,
                        handle: action.handle.value)

        CallAudio.configureAudioSession()

        call.connectedStateChanged = { [weak self, weak call] in
              guard
                    let self = self,
                    let call = call
                    else {
                      return
              }
              
              if call.connectedState == .pending {
                    self.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: nil)
              } else if call.connectedState == .complete {
                    self.provider.reportOutgoingCall(with: call.uuid, connectedAt: nil)
              }
        }

        call.start { [weak self, weak call] success in
              guard
                let self = self,
                let call = call
                else {
                  return
              }
              
              if success {
                    action.fulfill()
                    self.callManager.add(call: call)
              } else {
                    action.fail()
              }
        }
    }
    
}
