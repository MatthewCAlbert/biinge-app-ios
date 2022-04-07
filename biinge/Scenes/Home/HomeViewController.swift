//
//  HomeViewController.swift
//  biinge
//
//  Created by Matthew Christopher Albert on 07/04/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var helloLbl: UILabel!
    
    @IBAction func HelloButtonPressed(_ sender: UIButton) {
        helloLbl.text = "Hello World"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

