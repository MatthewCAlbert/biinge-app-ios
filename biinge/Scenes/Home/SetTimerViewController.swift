//
//  SetTimerViewController.swift
//  biinge
//
//  Created by Zidan Ramadhan on 07/04/22.
//

import UIKit

class SetTimerViewController: UIViewController {
        
    @IBOutlet weak var watchLimitPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func setLimitPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        let strTime = timeFormatter.string(from: watchLimitPicker.date)

        if segue.identifier == "goToSetTimer" {
            let destinationVC = segue.destination as! HomeViewController
            destinationVC.watchLimit = strTime
        }
    }
    
    
    
    
    
}
