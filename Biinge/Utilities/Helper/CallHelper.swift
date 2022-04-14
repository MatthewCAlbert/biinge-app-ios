//
//  CallHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation
import UIKit

struct LastCallInvocationProps {
    var callerName: String
    var delayInitialSeconds: Double
    var timeoutSeconds: Double?
}

class CallHelper {
    
    static let shared = CallHelper()
    var callManager: CallManager!
    var callDurationTimeout: Double? = 5.0
    
    var lastCallInvocationProps: LastCallInvocationProps?
    
    private init() {
        callManager = AppDelegate.shared.callManager
        
        callManager.callsChangedHandler = { [weak self] in
            guard let _ = self else { return }
        }
    }
    
    func call(callerName: String = "RestReminder", delayInitialSeconds: Double = 1.5, timeoutSeconds: Double? = 30.0) {
        let backgroundTaskIdentifier =
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + delayInitialSeconds) {
            self.lastCallInvocationProps = LastCallInvocationProps(callerName: callerName, delayInitialSeconds: delayInitialSeconds, timeoutSeconds: timeoutSeconds)
            
            AppDelegate.shared.displayIncomingCall(
                uuid: UUID(),
                handle: callerName
            ) { ( error ) in
                if error != nil {
                    self.onFailedToInvoke()
                }
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
            
            if let timeoutSeconds = timeoutSeconds {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeoutSeconds) {
                    print("check termination...")
                    if !self.callStateConnected {
                        print("terminating call...")
                        AppDelegate.shared.callManager.endFirst()
                    }
                }
            }
            
        }
        
        // MARK: outgoing call example DO NOT UNCOMMENT!
        // callManager.startCall(handle: callerName, videoEnabled: videoEnabled)
    }
    
    var callStateConnected: Bool = false {
        didSet {
            if self.failedToInvokeCount > 0 {
                self.failedToInvokeCount = 0
            }
            if self.callStateConnected {
                guard let callDurationTimeout = self.callDurationTimeout else {
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + callDurationTimeout) {
                    print("terminating after answered...")
                    AppDelegate.shared.callManager.endFirst()
                }
            }
        }
    }
    
    private var failedToInvokeCount: Int = 0 {
        didSet {
            if self.failedToInvokeCount > 0 && self.failedToInvokeCount < 3 {
                guard let lastCallInvocationProps = self.lastCallInvocationProps else { return }
                self.call(
                    callerName: lastCallInvocationProps.callerName,
                    delayInitialSeconds: lastCallInvocationProps.delayInitialSeconds,
                    timeoutSeconds: lastCallInvocationProps.timeoutSeconds
                )
            }
        }
    }
    
    // MARK: lifecycle
    
    private func onFailedToInvoke() {
        print("failed to invoke")
        self.failedToInvokeCount += 1
    }
    
    func onFailedToAnswer() {
        print("failed to answer")
    }
    
    func onSuccessToAnswer() {
        print("success to answer")
        self.callStateConnected = false
        
        // Do something here
        do {
            try SessionHelper.shared.autoDeterminePauseEnd()
        } catch {

        }
    }
    
}
