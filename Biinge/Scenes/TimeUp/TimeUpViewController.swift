//
//  TimeUpViewController.swift
//  Biinge
//
//  Created by Vincentius Ian Widi Nugroho on 13/04/22.
//

import UIKit
import Combine

class TimeUpViewController: UIViewController {
    var breakTitle: String = "Hold up, friend. It's Break time!"
    var timeUpTitle: String = "You’ve reached your watch time limit"
    var breakDesc: String = "Finding a way to refresh your mindand body can help you return with a clear mind."
    var timeUpDesc: String = "You can control yourself, congratulations! Claim your rewards now."
    var breakCenter: String = "Break Time!"
    var timeUpCenter: String = "Time's Up!"
    var breakSlider: String = "Tap to Take a Break"
    var timeUpSlider: String = "Tap to Get a Reward"
    var pulseColor: UIColor?


    @IBOutlet weak var timeUpBtn: UIButton!
    @IBOutlet weak var rewardBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var sessionSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sessionSubscriber = SessionHelper.shared.publisher.sink(
            receiveValue: { session in
                let miniSessionRemain = SessionHelper.shared.sessionMessage.currentMiniSessionLengthSeconds
                let seconds = miniSessionRemain - SessionHelper.shared.sessionMessage.miniSessionElapsedInSeconds
                let (_, m, s) = self.secondsToHoursMinutesSeconds(abs(seconds))
                self.timerLabel.text = (seconds < 0 ? "-" : "") + String(format: "%02d:%02d", m, s)
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setMode(SessionHelper.shared.isLastMiniSession)
        
        // Pulse
        pulse()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pulse()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.pulse()
        }
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func pulse(){
        let pulse = PulseAnimation(numberOfPulses: Float.infinity, radius: 200, position: timeUpBtn.center)
        pulse.backgroundColor = pulseColor!.cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
        self.view.bringSubviewToFront(timeUpBtn)
    }
    
    func setMode(_ isBreak: Bool){
        if (isBreak){
            titleLabel.text = timeUpTitle
            descLabel.text = timeUpDesc
            timeUpBtn.titleLabel?.text = timeUpCenter
            rewardBtn.titleLabel?.text = timeUpSlider
            rewardBtn.backgroundColor = UIColor(rgb: 0xBB2024)
            pulseColor = UIColor(rgb: 0xBB2024)
        } else {
            titleLabel.text = breakTitle
            descLabel.text = breakDesc
            timeUpBtn.titleLabel?.text = breakCenter
            rewardBtn.titleLabel?.text = breakSlider
            rewardBtn.backgroundColor = UIColor(rgb: 0x065FF3)
            pulseColor = UIColor(rgb: 0x065FF3)
        }
        rewardBtn.layer.cornerRadius = 10
        rewardBtn.backgroundColor = pulseColor
        timeUpBtn.layer.cornerRadius = timeUpBtn.frame.height/2
        timeUpBtn.clipsToBounds = true
        timeUpBtn.backgroundColor = pulseColor
        timeUpBtn.titleLabel?.textAlignment = .center
        timeUpBtn.titleLabel?.numberOfLines = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onSlideBtn(_ sender: UIButton) {
        do {
            try SessionHelper.shared.autoDeterminePauseEnd()
        } catch {
            
        }
    }
}
