//
//  SetupProfileViewController.swift
//  Biinge
//
//  Created by Vincentius Ian Widi Nugroho on 08/04/22.
//

import UIKit

class SetupProfileViewController: UIViewController, UITextFieldDelegate{
    var image: UIImage = UIImage(named: "PersonPlaceholder")!
    let editImage: UIImage = UIImage(named: "circleedit.png")!
    var pic: NSData? = nil

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
        profileImage.image = image
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor(rgb: 0x8D8D92).cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        pic = image.jpegData(compressionQuality: 0.5)! as NSData
        UserProfile.shared.pic = pic!
        
        // buat style text field
        self.userField.delegate = self
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
            if tf == "" {
                Toast.show(message: "Please fill your username first", controller: self)
                return
            }
            UserProfile.shared.username = tf
        } else {
            Toast.show(message: "Please fill your username first", controller: self)
            return
        }
        UserProfile.shared.pic = pic!
        performSegue(withIdentifier: "goToOnboardingSetReminder", sender: self)
    }

    // Later Button Action
    @IBAction func laterNext(_ sender: UIButton) {
        
    }
    
    // edit profile button
    @IBAction func chooseProfile(){
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
            pic = image.jpegData(compressionQuality: 0.5)! as NSData
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


