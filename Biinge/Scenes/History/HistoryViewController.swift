//
//  HistoryViewController.swift
//  Biinge
//
//  Created by Zidan Ramadhan on 12/04/22.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var circularAccuracyView: CircularProgressView!
    
    //View Outlet
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var streaksView: UIView!
    @IBOutlet weak var accExView: UIView!
    @IBOutlet weak var totalBingeView: UIView!
    
    //Label Outlet
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var streaksLabel: UILabel!
    @IBOutlet weak var accLabel: UILabel!
    @IBOutlet weak var excLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var totalMinutesLabel: UILabel!
    
    let datePicker = UIDatePicker()
    var image: UIImage = UIImage(data: UserProfile.shared.pic as Data)!
    var totalWatchPerDay: Int = 0
    var accPerDay: Int = 0
    var excPerDay: Int = 0
    var pointsPerDay: Int = 0
    var streaksPerDay: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setView(view: pointsView)
        setView(view: streaksView)
        setView(view: accExView)
        setView(view: totalBingeView)

        //Profile Pic View
        profilePic.image = image
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor(rgb: 0x8D8D92).cgColor
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
        self.loadDayData(Date())
        
        self.createDatePicker()
    }
    
    func createDatePicker() {
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date()
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        dateTextField.textAlignment = .center
    }
    
    func loadDayData(_ date: Date) {
        //formatter to show date on textfield
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateSelectedString = formatter.string(from: date)
        dateTextField.text = dateSelectedString
        
        //Date picked to get user data per date
        let dateSelected = datePicker.date
        
        //Set total binge-watched from date selected
        totalWatchPerDay = SessionHelper.shared.getDayTotalTimeInSecond(dateSelected)
        let (h, m) = (totalWatchPerDay / 3600, (totalWatchPerDay % 3600) / 60)
        
        totalHoursLabel.text = String(h)
        totalMinutesLabel.text = String(m)
        
        //Set Points from date selected
        self.pointsPerDay = SessionHelper.shared.getDayTotalPoint(date)
        pointsLabel.text = "\(pointsPerDay) \nPoints"
        
        //Set Streaks from date selected
        self.streaksPerDay = UserProfile.shared.streak
        streaksLabel.text = "\(streaksPerDay) \nStreaks"
        
        
        //Set Accomplish & Exceed from date selected
        let (acc, exc) = SessionHelper.shared.getDayDoneSessionSuccessAndFail(dateSelected)
        accPerDay = acc
        excPerDay = exc
        accLabel.text = "\(accPerDay)/\(accPerDay + excPerDay)"
        excLabel.text = "\(excPerDay)/\(accPerDay + excPerDay)"

        self.circularAccuracyView.accomplish = accPerDay
        self.circularAccuracyView.exceed = excPerDay
    }
    
    @objc func donePressed() {
        self.loadDayData(datePicker.date)
        self.view.endEditing(true)
    }

    //MARK: - Shape the UIView
    func setView(view: UIView){
        // corner radius
        view.layer.cornerRadius = 10

        // border
        view.layer.borderWidth = 0.0
        view.layer.borderColor = UIColor.black.cgColor

        // shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 6.0
    }

}
