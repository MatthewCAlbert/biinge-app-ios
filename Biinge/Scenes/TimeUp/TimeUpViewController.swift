//
//  TimeUpViewController.swift
//  Biinge
//
//  Created by Vincentius Ian Widi Nugroho on 13/04/22.
//

import UIKit

class TimeUpViewController: UIViewController {
    var isBreak: Bool = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMode()
        rewardBtn.layer.cornerRadius = 10
        rewardBtn.backgroundColor = pulseColor
        timeUpBtn.layer.cornerRadius = timeUpBtn.frame.height/2
        timeUpBtn.clipsToBounds = true
        timeUpBtn.backgroundColor = pulseColor
        timeUpBtn.titleLabel?.textAlignment = .center
        timeUpBtn.titleLabel?.numberOfLines = 0
        pulse()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pulse()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.pulse()
        }
    }
    
    func pulse(){
        let pulse = PulseAnimation(numberOfPulses: Float.infinity, radius: 200, position: timeUpBtn.center)
        pulse.backgroundColor = pulseColor!.cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
        self.view.bringSubviewToFront(timeUpBtn)
    }
    
    func setMode(){
        if (isBreak){
            titleLabel.text = breakTitle
            descLabel.text = breakDesc
            timeUpBtn.titleLabel?.text = breakCenter
            rewardBtn.titleLabel?.text = breakSlider
            pulseColor = UIColor(rgb: 0x065FF3)
        } else {
            titleLabel.text = timeUpTitle
            descLabel.text = timeUpDesc
            timeUpBtn.titleLabel?.text = timeUpCenter
            rewardBtn.titleLabel?.text = timeUpSlider
            pulseColor = UIColor(rgb: 0xBB2024)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
