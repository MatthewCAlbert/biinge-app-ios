//
//  BreakViewController.swift
//  Biinge
//
//  Created by Nathania Joyce on 11/04/22.
//

import UIKit

class BreakViewController: UIViewController {

    
    //buat IBOutlet
    @IBOutlet weak var breakTime: UILabel!
    @IBOutlet weak var tipsText: UITextView!
    @IBOutlet weak var earnLbl: UILabel!
    @IBOutlet weak var pointsGet: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var viewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let breakGif = UIImage.gifImageWithName("breakGif")
        
        viewImage.image = breakGif
        // Do any additional setup after loading the view.
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
