//
//  HomeViewController.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 07/04/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    //Var for indicator & message
    var watchLimit: String!
    var breakLimit: String!
    var watchLimitMessage: String!
    var breakLimitMessage: String!
    
    @IBOutlet weak var progressBarView: CircularProgressView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var watchTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    
    @IBOutlet weak var watchReminderLabel: UILabel!
    @IBOutlet weak var breakReminderLabel: UILabel!
    
    @IBOutlet weak var timerStartEndBtn: UIButton!
    @IBOutlet weak var setTimeBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    // MARK: Reactive Timer
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    private func updateWatchTimer(_ seconds: Int) {
        let (h, m, s) = self.secondsToHoursMinutesSeconds(abs(seconds))
        watchTimeLabel.text = (seconds < 0 ? "-" : "") + String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    private func updateBreakTimer(_ seconds: Int) {
        let (h, m, s) = self.secondsToHoursMinutesSeconds(abs(seconds))
        breakTimeLabel.text = (seconds < 0 ? "-" : "") + String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    var sessionSubscriber: AnyCancellable?
    var endMessageSubscriber: AnyCancellable?
    var textSubscriber: AnyCancellable?

    
    // MARK: UI Lifecycle + Trigger
    
    func setProgressBarValue(_ valuePercentage: Int, isInverted: Bool = false) {
        let value = abs(valuePercentage > 100 ? 100 : valuePercentage)
        
        if isInverted {
            progressBarView.exceed = 100 - value
            progressBarView.accomplish = value
        } else {
            progressBarView.exceed = value
            progressBarView.accomplish = 100 - value
        }
    }
    
    func setTitleMode(_ type: String = "") {
        switch type {
        case "break":
            usernameLabel.text = "Do you have enough break time?"
            subtitleLbl.text = "You can resume your watch time now. Hope the main character won't ruin your mood!"
        case "time":
            usernameLabel.text = "Watch Time Remains"
            subtitleLbl.text = "This is your remaining time before it ends. Hope it enoughs to fulfill all your storyline curiousity!"
        default:
            usernameLabel.text = "Hi, \(UserProfile.shared.username ?? "Watcher")!"
            subtitleLbl.text = "You can start your binge-watching session.                 No worries, we will remind the times!"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitleMode()
        
        // Setup circle
        progressBarView.progressColor = UIColor(rgb: 0x065FF3)
        progressBarView.trackColor = UIColor(rgb: 0xD8D8D8)
        self.setProgressBarValue(0)
        
        // Setup Label
        self.updateWatchTimer(SetTimerRelay.shared.sessionMessage.sessionTimerLimitSeconds)
        self.updateBreakTimer(SetTimerRelay.shared.sessionMessage.breakTimerLimitSeconds)
        self.watchReminderLabel.text = SetTimerRelay.shared.sessionMessage.watchReminderLabel
        self.breakReminderLabel.text = SetTimerRelay.shared.sessionMessage.breakReminderLabel
        self.onReceiveSessionMessage(SessionHelper.shared.sessionMessage)
        self.onReceiveCaptionMessage(SetTimerRelay.shared.sessionMessage)
        self.toggleMode()
        
        // Subscribe
        self.textSubscriber = SetTimerRelay.shared.publisher.sink(
            receiveValue: self.onReceiveCaptionMessage
        )
        self.sessionSubscriber = SessionHelper.shared.publisher.sink(
            receiveValue: self.onReceiveSessionMessage
        )
        self.endMessageSubscriber = SessionHelper.shared.publishedEndSubject.sink(
            receiveValue: { sessionEndMessage in
                print(sessionEndMessage.type)
                switch sessionEndMessage.type {
                    case .success: // success break
                        self.performSegue(withIdentifier: "homeToBreakSplash", sender: self)
                    case .streak: // success session
                        self.performSegue(withIdentifier: "homeToStreakSplash", sender: self)
                    case .failed:
                        self.performSegue(withIdentifier: "homeToFailSplash", sender: self)
                    case .timeUp:
                        self.performSegue(withIdentifier: "homeToRestPulsing", sender: self)
                    case .none:
                        print("got none end message")
                }
            }
        )
        
        Task {
           await self.recheckPermission()
        }
    }
    
    func onReceiveCaptionMessage(_ message: SetTimerRelayMessage) {
        self.updateWatchTimer(message.sessionTimerLimitSeconds)
        self.updateBreakTimer(message.breakTimerLimitSeconds)
        self.watchReminderLabel.text = message.watchReminderLabel
        self.breakReminderLabel.text = message.breakReminderLabel
    }
    
    func onReceiveSessionMessage(_ sessionMessage: SessionMessage) {
        // Set total session length
        let sessionRemain = Settings.shared.sessionLengthInMinute * 60
        self.updateWatchTimer(sessionRemain - sessionMessage.sessionElapsedInSeconds)
        
        // Set mini session length
        let miniSessionRemain = sessionMessage.currentMiniSessionLengthSeconds
        self.updateBreakTimer(miniSessionRemain - sessionMessage.miniSessionElapsedInSeconds)
        
        // Update circular
        if self.breakTimeLabel.isHidden {
            if sessionRemain > 0 {
                self.setProgressBarValue(Int(Double(sessionMessage.sessionElapsedInSeconds) / Double(sessionRemain) * 100.0), isInverted: true)
            } else {
                self.setProgressBarValue(0)
            }
        } else {
            if miniSessionRemain > 0 {
                self.setProgressBarValue(Int(Double(sessionMessage.miniSessionElapsedInSeconds) / Double(miniSessionRemain) * 100.0), isInverted: true)
            } else {
                self.setProgressBarValue(0)
            }
        }
        
        
        // TODO: Update
        if sessionMessage.running {
            if sessionMessage.isPaused && self.timerStartEndBtn.title(for: .normal) != "Resume" {
                self.timerStartEndBtn.setTitle("Resume", for: .normal)
            } else if !sessionMessage.isPaused && self.timerStartEndBtn.title(for: .normal) != "Pause" {
                self.timerStartEndBtn.setTitle("Pause", for: .normal)
            }
        }
        
        if !sessionMessage.running && self.timerStartEndBtn.title(for: .normal) != "Play"{
            self.timerStartEndBtn.setTitle("Play", for: .normal)
        }
        
        // Disable set button
        if self.setTimeBtn.isEnabled && sessionMessage.running {
            self.setTimeBtn.isEnabled = false
            self.endBtn.isEnabled = true
        } else if !self.setTimeBtn.isEnabled && !sessionMessage.running {
            self.setTimeBtn.isEnabled = true
            self.endBtn.isEnabled = false
        }
        
        if SessionHelper.shared.isLastMiniSession {
            self.timerStartEndBtn.isEnabled = false
        } else {
            self.timerStartEndBtn.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !SessionHelper.shared.sessionMessage.running {
            self.breakTimeLabel.isHidden = true
            self.breakReminderLabel.isHidden = true
        }
    }
    
    func recheckPermission() async{
        let result: UNNotificationSettings = await NotificationHelper.shared.notificationCenter.notificationSettings()
        switch result.authorizationStatus {
            case .notDetermined:
                NotificationHelper.shared.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                })
            default:
                break
        }
    }
    
    @IBAction func didUnwindFromSetTimeVC(_ sender: UIStoryboardSegue) {
        watchTimeLabel.text = watchLimit
        breakTimeLabel.text = breakLimit
    }
    
    func toggleMode() {
        if breakTimeLabel.isHidden == false {
            breakTimeLabel.isHidden = true
            breakReminderLabel.isHidden = true
            
            watchTimeLabel.isHidden = false
            watchReminderLabel.isHidden = false
            self.setTitleMode("time")
        } else {
            breakTimeLabel.isHidden = false
            breakReminderLabel.isHidden = false
            
            watchTimeLabel.isHidden = true
            watchReminderLabel.isHidden = true
            self.setTitleMode("break")
        }
    }
    
    @IBAction func changeModePressed(_ sender: UIButton) {
        self.toggleMode()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToInfo", sender: self)
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        if breakTimeLabel.isHidden == true {
            self.setTitleMode("time")
        } else {
            self.setTitleMode("break")
        }
        do {
            if !SessionHelper.shared.sessionMessage.running {
                try SessionHelper.shared.start()
            } else {
                if SessionHelper.shared.sessionMessage.isPaused {
                    try SessionHelper.shared.start() // resume
                } else {
                    try SessionHelper.shared.pause()
                }
            }
        } catch {
            
        }
    }
    @IBAction func endPressed(_ sender: UIButton) {
        self.setTitleMode()
        do {
            if SessionHelper.shared.sessionMessage.running {
                try SessionHelper.shared.end()
            }
        } catch {
            
        }
    }
    
}


