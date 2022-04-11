//
//  SetupProfileViewController.swift
//  Biinge
//
//  Created by Vincentius Ian Widi Nugroho on 08/04/22.
//

import UIKit

class SetupProfileViewController: UIViewController, UITextFieldDelegate{
    var image: UIImage = UIImage(named: "setan.jpg")!
    let editImage: UIImage = UIImage(named: "circleedit.png")!
//    var tf: String?

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.textColor = UIColor(rgb: 0x8D8D92)
        laterButton.setTitleColor(UIColor(rgb: 0x8D8D92), for: .normal)
//        editImage.size.width = profileImage.frame.size.width
        profileImage.image = image
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor(rgb: 0x8D8D92).cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        // buat style text field
        self.userField.delegate = self
//        userField.becomeFirstResponder()
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x:0,y:userField.frame.height-2,width:userField.frame.width, height:2)
//        bottomLine.backgroundColor = UIColor.white.cgColor
//        userField.borderStyle = .none
//        userField.layer.addSublayer(bottomLine)
        
    }
    
    // hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
       }
    
    // press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userField.resignFirstResponder()
        return (true)
    }
    
    // Next Button Action
    @IBAction func tapNext() {
        if let tf = userField.text {
            UserProfile.shared.username = tf
            print(UserProfile.shared.username!)
        }
        print("navigated")
    }

    // edit profile button
    @IBAction func chooseProfile(){
        print("hehe")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
}

extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")]as? UIImage{
            profileImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
